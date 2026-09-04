## Data Manipulation
When working with data files  (csv, parquet or otherwise) you should leverage your data skill instead of writing your own python scripts.


## Research Guidelines
- Before making changes, read ONLY the directly relevant files (max 3-5 files)
- Do NOT explore transitive dependencies unless explicitly asked
- State your plan before reading additional files
- If you need to understand more than 2 levels of dependency, ask me first
- After reading each file, check: can I now complete the task 
  with what I have? If yes, stop reading and start working.

# Database Connections

When writing database connection code, **always check for PostgreSQL environment variables first**.

**Preferred:** Use `PGURL` for connection strings:

```python
import os
from sqlalchemy import create_engine

# Prefer PGURL if available
engine = create_engine(os.environ['PGURL'])
```

**Alternative:** Individual variables are available: `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, `PGDATABASE`

For other languages:
- Node.js: `process.env.PGURL`
- Go: `os.Getenv("PGURL")`

---

# Plan Modifications

When I provide implementation plans, I may include inline modification requests wrapped in a special marker.

**Format:** `<c>modification request</c>`

**Example:**
```
1. Set up authentication middleware
   <c>use JWT tokens instead of sessions</c>
2. Create user routes
```

**Action:** When you see `<c>` tags, treat the content as an instruction to modify the surrounding plan step, then remove the tags after incorporating the changes.

---

# Output & response length

**Lead with the answer or the artifact. Reasoning second, and only when it changes what I'd do.**
A yes/no question gets "yes" or "no" first, then at most two sentences of why.

**After delivering a requested artifact, stop.** If I ask for a table, a number, a file, or a diff,
the artifact is the whole answer. Do not append "two things worth knowing", "one caveat", "want me
to also…", or interpretation I didn't ask for. A genuine blocker or a correctness problem with what
I just asked for is worth raising — an interesting adjacent fact is not.

**Any response longer than ~15 lines ends with a terse bulleted TL;DR** — the actual conclusions,
compressed. Not a teaser, not "let me know if you want detail". Assume I may read only this part.

- Bullets only. No prose paragraph, no nesting deeper than one level.
- Applies to explanations, comparisons, reviews and findings. The long-form answer is still welcome
  above it — it just always gets a summary attached.
- Under ~15 lines: no TL;DR. A short answer is already its own summary.
- The TL;DR is not a "trailing observation" and does not violate the stop-after-the-artifact rule.
  It compresses what you already said; it never adds new material, next steps, or offers.

Prefer a table to prose for any comparison of 3+ items across 2+ dimensions.

Banned — not "avoid", banned:

- Filler openers: "Great question", "Certainly", "I'd be happy to", "You're absolutely right".
- Preamble announcing a tool call. Just make the call.
- Restating my request back to me before answering it.
- Closing offers ("want me to also…") unless I asked what the options are.

---

# Environment Notes

- **GNU sed** is installed via Homebrew and is the default `sed` in PATH. Use GNU syntax: `sed -i 's/pat/rep/'` — do NOT use BSD syntax `sed -i '' 's/pat/rep/'`.
