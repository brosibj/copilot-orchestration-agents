```markdown
# Project Settings

> Primary configuration file for project-specific standards. Update this file to adapt the template for your project.

## Stack
| Component | Technology |
|:---|:---|
| Language | C# 14 |
| Runtime | .NET 10.0 |
| UI Framework | ASP.NET Core Blazor Server + Radzen.Blazor |
| ORM | Entity Framework Core |
| Error Handling | FluentResults (`Result<T>` pattern) |
| Background Jobs | Hangfire (`IBackgroundJobClient`) |

## Packages
| Package | Purpose |
|:---|:---|
| Radzen.Blazor | UI component library |
| Microsoft.EntityFrameworkCore | ORM — migrations managed by `@migrator` |
| Microsoft.EntityFrameworkCore.Sqlite | Integration test database provider |
| FluentResults | `Result<T>` for service logic flow / expected failures |
| Hangfire | Background job scheduling via `IBackgroundJobClient` |

## Build & Validation
| Command | Purpose | Gate |
|:---|:---|:---|
| `dotnet build --no-incremental` | Full rebuild | 0 errors, 0 warnings |
| `dotnet test` | Run all tests | 0 failures |
| `dotnet add package <Name>` | Add package (no version — pulls latest) | Get user confirmation before adding new packages |
| `dotnet list package` | Audit installed packages | — |

- **Project files:** Never create or modify `.csproj` files manually. Use `dotnet` CLI commands for all project operations (add/remove packages, add references, etc.). Manual `.csproj` edits are only permitted when no `dotnet` command exists for the required operation.

## Migrations (EF Core)
- **Clean History:** Determine from input if a new migration should be added or rolled back and re-added.

| Type | Command Sequence |
|:---|:---|
| **New** | `dotnet ef migrations add <Name>` → `dotnet ef database update` |
| **Rollback & Readd** | `dotnet ef database update <Prev>` → `dotnet ef migrations remove` → `dotnet ef migrations add <Name>` → `dotnet ef database update` |

## Coding Standards
- **Patterns:** DRY/ACID, SoC, SRP, DI (prefer over static/singletons). Use constants over magic values.
- **Error Handling:** Use `FluentResults.Result` for logic flow or for failures expected during normal operation; Exceptions only for technical failures (catch/log at top-level).
- **Quality:** Resolve all build warnings. XML comments for public members; `// TODO:` for pending work including github issue number.
- **Constructor DI only** — no static singletons.

## Asset Rules
- **NO CSS/JS in `.razor` files.**
- **CSS:** Codebehind css file for custom components (`.razor.css`), or `app.css` for global styles that apply to elements we don't own (`div`, elements provided by packages, etc).
- **JS:** Use `wwwroot/`. Minimal JS & CSS only when mandatory.

## Service Data Access Patterns
| Context | Pattern | Strategy |
|:---|:---|:---|
| **Services / Repositories** | `IDbContextFactory` | Short-lived `await using`, `AsNoTracking()` for reads. |
| **Read/List pages** | `IDbContextFactory` | `AsNoTracking()` for performance. |

> For UI component data access patterns (OwningComponentBase, etc.), see `styleguide.md`.

## Debugger Tier Scoping
> Used by triage and orchestrators to route bugs to the correct debugger.

| Tier | Agent | Scope |
|:---|:---|:---|
| 1 — Medic | `@debugger-medic` | Compiler/syntax/simple null-check issues |
| 2 — Detective | `@debugger-detective` | Blazor state/lifecycle/circuit/race-condition issues |
| 3 — Specialist | `@debugger-specialist` | EF Core/SQL/API routing/data-service issues |
| 4 — Forensic | `@debugger-forensic` | DI/architecture/memory-leak issues |
```