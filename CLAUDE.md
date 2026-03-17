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

# Environment Notes

- **GNU sed** is installed via Homebrew and is the default `sed` in PATH. Use GNU syntax: `sed -i 's/pat/rep/'` — do NOT use BSD syntax `sed -i '' 's/pat/rep/'`.
