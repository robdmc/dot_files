#!/usr/bin/env python3
"""Analyze Claude Code session logs by skill usage with token/cost breakdown."""

import json
import pathlib
import collections
import datetime
import argparse
import sys
import re
import csv


# Claude Sonnet 4.5 pricing (per token)
INPUT_COST = 3.00 / 1_000_000
OUTPUT_COST = 15.00 / 1_000_000
CACHE_READ_COST = 0.30 / 1_000_000
CACHE_CREATION_COST = 3.75 / 1_000_000


def parse_date_arg(s):
    """Parse a human-friendly date string into a datetime object."""
    s_lower = s.strip().lower()
    today = datetime.date.today()

    # Named intervals
    intervals = {
        "today": lambda: datetime.datetime.combine(today, datetime.time.min),
        "yesterday": lambda: datetime.datetime.combine(today - datetime.timedelta(days=1), datetime.time.min),
        "this week": lambda: datetime.datetime.combine(today - datetime.timedelta(days=today.weekday()), datetime.time.min),
        "last week": lambda: datetime.datetime.combine(today - datetime.timedelta(days=today.weekday() + 7), datetime.time.min),
        "this month": lambda: datetime.datetime.combine(today.replace(day=1), datetime.time.min),
        "last month": lambda: datetime.datetime.combine((today.replace(day=1) - datetime.timedelta(days=1)).replace(day=1), datetime.time.min),
    }

    if s_lower in intervals:
        return intervals[s_lower]()

    # "last N days" pattern
    m = re.match(r"last\s+(\d+)\s+days?", s_lower)
    if m:
        return datetime.datetime.combine(
            today - datetime.timedelta(days=int(m.group(1))),
            datetime.time.min,
        )

    # ISO format: YYYY-MM-DDTHH:MM:SS or YYYY-MM-DD
    for fmt in ("%Y-%m-%dT%H:%M:%S", "%Y-%m-%d", "%m/%d/%Y", "%Y%m%d"):
        try:
            return datetime.datetime.strptime(s.strip(), fmt)
        except ValueError:
            continue

    # Try ISO with fractional seconds / Z suffix
    try:
        cleaned = re.sub(r"\.\d+", "", s.strip()).replace("Z", "")
        return datetime.datetime.strptime(cleaned, "%Y-%m-%dT%H:%M:%S")
    except ValueError:
        pass

    # Show helpful error with valid options
    valid_intervals = ", ".join(f'"{k}"' for k in sorted(intervals.keys()))
    print(f"Error: Cannot parse date '{s}'", file=sys.stderr)
    print(f"Valid intervals: {valid_intervals}", file=sys.stderr)
    print(f"Also accepts: ISO dates (YYYY-MM-DD), 'last N days'", file=sys.stderr)
    sys.exit(1)


def parse_timestamp(ts_str):
    """Parse an ISO 8601 timestamp string to a datetime."""
    if not ts_str:
        return None
    try:
        cleaned = re.sub(r"\.\d+", "", ts_str).replace("Z", "")
        return datetime.datetime.strptime(cleaned, "%Y-%m-%dT%H:%M:%S")
    except (ValueError, TypeError):
        return None


def extract_usage(message):
    """Extract token usage dict from an assistant message."""
    msg = message.get("message", {})
    usage = msg.get("usage", {})
    return {
        "input": usage.get("input_tokens", 0) or 0,
        "output": usage.get("output_tokens", 0) or 0,
        "cache_read": usage.get("cache_read_input_tokens", 0) or 0,
        "cache_creation": usage.get("cache_creation_input_tokens", 0) or 0,
    }


def calculate_cost(tokens):
    """Calculate cost from a token breakdown dict."""
    return (
        tokens.get("input", 0) * INPUT_COST
        + tokens.get("output", 0) * OUTPUT_COST
        + tokens.get("cache_read", 0) * CACHE_READ_COST
        + tokens.get("cache_creation", 0) * CACHE_CREATION_COST
    )


def tokens_total(tokens):
    return (
        tokens.get("input", 0)
        + tokens.get("output", 0)
        + tokens.get("cache_read", 0)
        + tokens.get("cache_creation", 0)
    )


def add_tokens(a, b):
    """Add two token dicts together."""
    return {
        "input": a.get("input", 0) + b.get("input", 0),
        "output": a.get("output", 0) + b.get("output", 0),
        "cache_read": a.get("cache_read", 0) + b.get("cache_read", 0),
        "cache_creation": a.get("cache_creation", 0) + b.get("cache_creation", 0),
    }


def zero_tokens():
    return {"input": 0, "output": 0, "cache_read": 0, "cache_creation": 0}


def discover_sessions():
    """Find all top-level JSONL session files under ~/.claude/projects/."""
    claude_dir = pathlib.Path.home() / ".claude" / "projects"
    if not claude_dir.exists():
        return []

    files = []
    for p in claude_dir.rglob("*.jsonl"):
        # Skip subagent files
        if "subagents" in p.parts:
            continue
        files.append(p)
    return sorted(files)


def parse_session(filepath):
    """Parse a JSONL session file into a structured session dict."""
    messages = []
    session_id = filepath.stem
    session_ts = None

    with open(filepath, "r", errors="replace") as f:
        for line_num, line in enumerate(f):
            line = line.strip()
            if not line:
                continue
            try:
                obj = json.loads(line)
            except json.JSONDecodeError:
                continue

            msg_type = obj.get("type")

            # Only count actual conversation messages (user and assistant)
            # Skip progress updates, file-history-snapshot, system messages, etc.
            if msg_type not in ("user", "assistant"):
                continue

            ts = parse_timestamp(obj.get("timestamp"))
            if ts and session_ts is None:
                session_ts = ts

            messages.append(
                {
                    "index": line_num,
                    "type": msg_type,
                    "timestamp": ts,
                    "usage": extract_usage(obj) if msg_type == "assistant" else zero_tokens(),
                    "content": obj.get("message", {}).get("content", []),
                    "raw_type": msg_type,
                }
            )

    return {
        "session_id": session_id,
        "filepath": filepath,
        "timestamp": session_ts,
        "messages": messages,
    }


def detect_skill_invocations(content):
    """Return set of skill names invoked in a message's content blocks."""
    skills = set()
    if not isinstance(content, list):
        return skills
    for block in content:
        if not isinstance(block, dict):
            continue
        if block.get("type") == "tool_use" and block.get("name") == "Skill":
            inp = block.get("input", {})
            skill_name = inp.get("skill") or inp.get("command")
            if skill_name:
                skills.add(skill_name)
    return skills


def build_skill_ranges(session):
    """Build token ranges grouped by active skill sets for a session."""
    messages = session["messages"]
    if not messages:
        return []

    ranges = []
    current_skills = set()
    current_range = None

    def new_range(start_idx, skills_frozen):
        return {
            "start": start_idx,
            "end": start_idx,
            "skills": skills_frozen,
            "tokens": zero_tokens(),
            "message_count": 0,
        }

    for msg in messages:
        invoked = detect_skill_invocations(msg["content"])

        # If new skills are invoked, close current range and start a new one
        if invoked and invoked - current_skills:
            current_skills = current_skills | invoked
            if current_range and current_range["message_count"] > 0:
                ranges.append(current_range)
            current_range = new_range(msg["index"], frozenset(current_skills))

        if current_range is None:
            current_range = new_range(msg["index"], frozenset(current_skills) if current_skills else frozenset())

        current_range["end"] = msg["index"]
        current_range["tokens"] = add_tokens(current_range["tokens"], msg["usage"])
        current_range["message_count"] += 1

    if current_range and current_range["message_count"] > 0:
        ranges.append(current_range)

    return ranges


def process_sessions(session_files):
    """Parse all sessions and build skill ranges."""
    sessions = []
    for fp in session_files:
        session = parse_session(fp)
        if not session["messages"]:
            continue
        session["ranges"] = build_skill_ranges(session)

        # Compute session totals
        total_tokens = zero_tokens()
        for r in session["ranges"]:
            total_tokens = add_tokens(total_tokens, r["tokens"])
        session["total_tokens"] = total_tokens
        session["total_cost"] = calculate_cost(total_tokens)
        session["total_messages"] = len(session["messages"])

        # Collect all skills used in session
        all_skills = set()
        for r in session["ranges"]:
            all_skills |= r["skills"]
        session["all_skills"] = all_skills

        sessions.append(session)
    return sessions


def filter_sessions(sessions, args):
    """Apply filtering pipeline to sessions."""
    result = sessions

    # Time range filter
    if args.since:
        since = parse_date_arg(args.since)
        result = [s for s in result if s["timestamp"] is None or s["timestamp"] >= since]
    if args.until:
        until = parse_date_arg(args.until)
        result = [s for s in result if s["timestamp"] is None or s["timestamp"] <= until]

    # Skill filter
    if args.skill:
        skill_lower = args.skill.lower()
        result = [
            s for s in result
            if any(skill_lower in sk.lower() for sk in s["all_skills"])
        ]

    # Min cost filter
    if args.min_cost is not None:
        result = [s for s in result if s["total_cost"] >= args.min_cost]

    # Sort by cost descending
    result.sort(key=lambda s: s["total_cost"], reverse=True)

    # Top N
    if args.top:
        result = result[: args.top]

    return result


def build_summary(sessions):
    """Build per-skill summary aggregates across all sessions."""
    summary = collections.defaultdict(lambda: {
        "session_ids": set(),
        "message_count": 0,
        "tokens": zero_tokens(),
        "total_cost": 0.0,
    })

    for session in sessions:
        for r in session["ranges"]:
            skills = r["skills"] if r["skills"] else frozenset(["[No Skills]"])
            n_skills = len(skills)
            fraction = 1.0 / n_skills

            for skill in skills:
                entry = summary[skill]
                entry["session_ids"].add(session["session_id"])
                entry["message_count"] += r["message_count"]
                fractional_tokens = {
                    k: v * fraction for k, v in r["tokens"].items()
                }
                entry["tokens"] = add_tokens(entry["tokens"], fractional_tokens)
                entry["total_cost"] += calculate_cost(r["tokens"]) * fraction

    return dict(summary)


def fmt_cost(cost):
    """Format a cost value as a dollar string."""
    if cost < 0.01:
        return f"${cost:.4f}"
    return f"${cost:.2f}"


def cost_breakdown(tokens):
    """Return per-type cost dict for a token breakdown dict."""
    return {
        "input": tokens.get("input", 0) * INPUT_COST,
        "output": tokens.get("output", 0) * OUTPUT_COST,
        "cache_read": tokens.get("cache_read", 0) * CACHE_READ_COST,
        "cache_creation": tokens.get("cache_creation", 0) * CACHE_CREATION_COST,
    }


def fmt_num(n):
    """Format a number with comma separators."""
    if isinstance(n, float):
        return f"{n:,.0f}"
    return f"{n:,}"


def format_text(sessions, summary, args):
    """Format output as human-readable text."""
    lines = []

    if not sessions:
        lines.append("No sessions found matching filters.")
        return "\n".join(lines)

    total_cost_all = sum(s["total_cost"] for s in sessions)
    lines.append(f"Found {len(sessions)} session(s), total cost: {fmt_cost(total_cost_all)}")
    lines.append("")

    # Per-session detail
    if not args.summary_only:
        lines.append("SESSION DETAILS")
        lines.append("-" * 160)
        lines.append(
            f"{'Session ID':<20} {'Time':<17} {'Msgs':>5} {'Skills':<30} "
            f"{'In':>9} {'Out':>9} {'C.Read':>9} {'C.Create':>9} "
            f"{'$In':>8} {'$Out':>8} {'$C.Rd':>8} {'$C.Cr':>8} {'Cost':>9}"
        )
        lines.append("-" * 160)

        for s in sessions:
            ts_str = s["timestamp"].strftime("%Y-%m-%d %H:%M") if s["timestamp"] else "unknown"

            for idx, r in enumerate(s["ranges"]):
                skill_label = ", ".join(sorted(r["skills"])) if r["skills"] else "[No Skills]"
                if len(skill_label) > 30:
                    skill_label = skill_label[:27] + "..."

                t = r["tokens"]
                cb = cost_breakdown(t)

                # Show session ID only on first range
                session_col = s['session_id'][:18] if idx == 0 else ""
                time_col = ts_str if idx == 0 else ""
                msg_col = f"{s['total_messages']}" if idx == 0 else ""

                lines.append(
                    f"{session_col:<20} {time_col:<17} {msg_col:>5} {skill_label:<30} "
                    f"{fmt_num(t['input']):>9} {fmt_num(t['output']):>9} "
                    f"{fmt_num(t['cache_read']):>9} {fmt_num(t['cache_creation']):>9} "
                    f"{fmt_cost(cb['input']):>8} {fmt_cost(cb['output']):>8} "
                    f"{fmt_cost(cb['cache_read']):>8} {fmt_cost(cb['cache_creation']):>8} "
                    f"{fmt_cost(calculate_cost(t)):>9}"
                )

        lines.append("")

    # Summary
    lines.append("")
    lines.append("SKILL SUMMARY")
    lines.append("-" * 155)

    sorted_skills = sorted(summary.items(), key=lambda x: x[1]["total_cost"], reverse=True)

    # Header
    lines.append(
        f"{'Skill':<35} {'Sess':>5} {'Msgs':>8} "
        f"{'Input':>11} {'Output':>11} {'C.Read':>11} {'C.Create':>11} "
        f"{'$Input':>9} {'$Output':>9} {'$C.Read':>9} {'$C.Cre':>9} {'Cost':>10}"
    )
    lines.append("-" * 155)

    for skill, data in sorted_skills:
        skill_display = skill if len(skill) <= 33 else skill[:30] + "..."
        t = data["tokens"]
        cb = cost_breakdown(t)
        lines.append(
            f"{skill_display:<35} {len(data['session_ids']):>5} {data['message_count']:>8} "
            f"{fmt_num(t['input']):>11} {fmt_num(t['output']):>11} "
            f"{fmt_num(t['cache_read']):>11} {fmt_num(t['cache_creation']):>11} "
            f"{fmt_cost(cb['input']):>9} {fmt_cost(cb['output']):>9} "
            f"{fmt_cost(cb['cache_read']):>9} {fmt_cost(cb['cache_creation']):>9} "
            f"{fmt_cost(data['total_cost']):>10}"
        )

    lines.append("-" * 155)

    # Totals
    total_tokens_all = zero_tokens()
    total_msgs = 0
    total_sess = set()
    for data in summary.values():
        total_tokens_all = add_tokens(total_tokens_all, data["tokens"])
        total_msgs += data["message_count"]
        total_sess |= data["session_ids"]

    t = total_tokens_all
    cb = cost_breakdown(t)
    lines.append(
        f"{'TOTAL':<35} {len(total_sess):>5} {total_msgs:>8} "
        f"{fmt_num(t['input']):>11} {fmt_num(t['output']):>11} "
        f"{fmt_num(t['cache_read']):>11} {fmt_num(t['cache_creation']):>11} "
        f"{fmt_cost(cb['input']):>9} {fmt_cost(cb['output']):>9} "
        f"{fmt_cost(cb['cache_read']):>9} {fmt_cost(cb['cache_creation']):>9} "
        f"{fmt_cost(total_cost_all):>10}"
    )
    lines.append("")

    return "\n".join(lines)


def format_json(sessions, summary, args):
    """Format output as JSON."""
    output = {
        "filters": {
            "since": args.since,
            "until": args.until,
            "skill": args.skill,
            "min_cost": args.min_cost,
            "top": args.top,
        },
        "sessions": [],
        "summary": {},
    }

    for s in sessions:
        session_out = {
            "session_id": s["session_id"],
            "timestamp": s["timestamp"].isoformat() if s["timestamp"] else None,
            "total_messages": s["total_messages"],
            "total_tokens": s["total_tokens"],
            "total_cost": round(s["total_cost"], 6),
            "skills": sorted(s["all_skills"]),
            "ranges": [],
        }
        for r in s["ranges"]:
            cb = cost_breakdown(r["tokens"])
            session_out["ranges"].append({
                "start": r["start"],
                "end": r["end"],
                "skills": sorted(r["skills"]),
                "tokens": r["tokens"],
                "cost": round(calculate_cost(r["tokens"]), 6),
                "cost_breakdown": {k: round(v, 6) for k, v in cb.items()},
                "message_count": r["message_count"],
            })
        output["sessions"].append(session_out)

    for skill, data in summary.items():
        cb = cost_breakdown(data["tokens"])
        output["summary"][skill] = {
            "session_count": len(data["session_ids"]),
            "message_count": data["message_count"],
            "tokens": {k: round(v, 2) for k, v in data["tokens"].items()},
            "total_cost": round(data["total_cost"], 6),
            "cost_breakdown": {k: round(v, 6) for k, v in cb.items()},
        }

    return json.dumps(output, indent=2)


def format_csv(sessions, summary, args):
    """Format output as CSV with section indicators."""
    import io
    output = io.StringIO()
    writer = csv.writer(output)

    # Header
    writer.writerow([
        "section",
        "session_id",
        "timestamp",
        "range_start",
        "range_end",
        "skills",
        "message_count",
        "input_tokens",
        "output_tokens",
        "cache_read_tokens",
        "cache_creation_tokens",
        "total_tokens",
        "input_cost",
        "output_cost",
        "cache_read_cost",
        "cache_creation_cost",
        "cost",
    ])

    # Session detail rows (skip if --summary-only)
    if not args.summary_only:
        for s in sessions:
            ts_str = s["timestamp"].strftime("%Y-%m-%d %H:%M:%S") if s["timestamp"] else ""

            for r in s["ranges"]:
                t = r["tokens"]
                cb = cost_breakdown(t)
                skills_str = ", ".join(sorted(r["skills"])) if r["skills"] else "[No Skills]"

                writer.writerow([
                    "session_range",
                    s["session_id"],
                    ts_str,
                    r["start"],
                    r["end"],
                    skills_str,
                    r["message_count"],
                    t["input"],
                    t["output"],
                    t["cache_read"],
                    t["cache_creation"],
                    tokens_total(t),
                    round(cb["input"], 6),
                    round(cb["output"], 6),
                    round(cb["cache_read"], 6),
                    round(cb["cache_creation"], 6),
                    round(calculate_cost(t), 6),
                ])

    # Summary rows
    sorted_skills = sorted(summary.items(), key=lambda x: x[1]["total_cost"], reverse=True)

    for skill, data in sorted_skills:
        t = data["tokens"]
        cb = cost_breakdown(t)
        writer.writerow([
            "summary",
            "",  # no session_id for summary
            "",  # no timestamp for summary
            "",  # no range_start
            "",  # no range_end
            skill,
            data["message_count"],
            round(t["input"], 2),
            round(t["output"], 2),
            round(t["cache_read"], 2),
            round(t["cache_creation"], 2),
            round(tokens_total(t), 2),
            round(cb["input"], 6),
            round(cb["output"], 6),
            round(cb["cache_read"], 6),
            round(cb["cache_creation"], 6),
            round(data["total_cost"], 6),
        ])

    # Total row
    total_tokens_all = zero_tokens()
    total_msgs = 0
    total_cost_all = 0.0
    for data in summary.values():
        total_tokens_all = add_tokens(total_tokens_all, data["tokens"])
        total_msgs += data["message_count"]
        total_cost_all += data["total_cost"]

    t = total_tokens_all
    cb = cost_breakdown(t)
    writer.writerow([
        "total",
        "",
        "",
        "",
        "",
        "TOTAL",
        total_msgs,
        round(t["input"], 2),
        round(t["output"], 2),
        round(t["cache_read"], 2),
        round(t["cache_creation"], 2),
        round(tokens_total(t), 2),
        round(cb["input"], 6),
        round(cb["output"], 6),
        round(cb["cache_read"], 6),
        round(cb["cache_creation"], 6),
        round(total_cost_all, 6),
    ])

    return output.getvalue()


def main():
    parser = argparse.ArgumentParser(
        description="Analyze Claude Code session logs by skill usage with token/cost breakdown.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""\
examples:
  %(prog)s --since "this month"
  %(prog)s --since "last week"
  %(prog)s --since today --summary-only
  %(prog)s --skill blueberry-sql --top 5
  %(prog)s --since 2026-01-15 --until 2026-01-31 --min-cost 0.50
  %(prog)s --format json | python3 -m json.tool
  %(prog)s --since yesterday --format json
  %(prog)s --format csv > sessions.csv
""",
    )
    parser.add_argument("--since", default="today", help="Show sessions from this date (default: today). Options: 'today', 'yesterday', 'this week', 'last week', 'this month', 'last month', 'last N days', or YYYY-MM-DD")
    parser.add_argument("--until", help="Show sessions up to this date")
    parser.add_argument("--skill", help="Filter to sessions that use this skill (substring match)")
    parser.add_argument("--min-cost", type=float, help="Minimum session cost to include")
    parser.add_argument("--summary-only", action="store_true", help="Only show the skill summary, skip per-session detail")
    parser.add_argument("--top", type=int, help="Show only the top N sessions by cost")
    parser.add_argument("--format", choices=["text", "json", "csv"], default="text", help="Output format (default: text)")

    args = parser.parse_args()

    # Discover and parse sessions
    session_files = discover_sessions()
    if not session_files:
        print("No session files found in ~/.claude/projects/", file=sys.stderr)
        sys.exit(1)

    sessions = process_sessions(session_files)
    sessions = filter_sessions(sessions, args)

    summary = build_summary(sessions)

    if args.format == "json":
        print(format_json(sessions, summary, args))
    elif args.format == "csv":
        print(format_csv(sessions, summary, args))
    else:
        print(format_text(sessions, summary, args))


if __name__ == "__main__":
    main()
