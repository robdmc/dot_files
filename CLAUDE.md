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
