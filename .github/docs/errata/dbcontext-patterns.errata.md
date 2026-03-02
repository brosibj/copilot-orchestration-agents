# DbContext Patterns
| Component Type | Pattern | Strategy |
| :--- | :--- | :--- |
| **Edit/Detail Pages** | `OwningComponentBase` | Scoped context, `ChangeTracker` for dirty state, Concurrency handling. |
| **Read/List/Services** | `IDbContextFactory` | Short-lived `await using`, `AsNoTracking()` for performance. |
| **Hybrid** | Mixed | `OwningComponentBase` for main entity; Services for lookups. |