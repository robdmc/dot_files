## Database Connections

When connecting to PostgreSQL databases, check for the `PGURL` environment variable:

```python
import os
from sqlalchemy import create_engine

engine = create_engine(os.environ['PGURL'])
```

Individual PG* variables are also available: `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, `PGDATABASE`.


# Claude plans
The user will frequently edit claude plans and ask you to incorporate changes.
Assume that content between like the following are directives for you to change the plan 
<c>this will be instructions on how i want you to modify plan</c>
