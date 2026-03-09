# Project Settings

> Primary configuration file for project-specific standards. Update this file to adapt the template for your project.

## Stack & Packages
| Component | Package / Technology | Notes |
|:---|:---|:---|
| Language | C# 14 | — |
| Runtime | .NET 10.0 | — |
| UI Framework | ASP.NET Core Blazor Server | — |
| UI Components | Radzen.Blazor | Component library |
| ORM | Microsoft.EntityFrameworkCore | Migrations managed by `@migrator` |
| Error Handling | FluentResults | `Result<T>` for service logic flow / expected failures |
| Background Jobs | Hangfire | Via `IBackgroundJobClient` |

## Build & Validation
| Command | Purpose | Gate |
|:---|:---|:---|
| `dotnet build --no-incremental` | Full rebuild | 0 errors, 0 warnings |
| `dotnet add package <Name>` | Add package (no version — pulls latest) | Get user confirmation before adding new packages |
| `dotnet list package` | Audit installed packages | — |

- **Gates are hard blocks.** Regressions (previously-passing tests now failing) must be resolved. New test failures block unless justified in `plan.md` → **Known Test Limitations**.
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

## Service Data Access Patterns
| Context | Pattern | Strategy |
|:---|:---|:---|
| **Services / Repositories** | `IDbContextFactory` | Short-lived `await using`, `AsNoTracking()` for reads. |

> For UI component data access patterns (OwningComponentBase, IDbContextFactory in pages, etc.), see `styleguide.md`.

## MCP Tool Guidance (Optional)
> Populate this section to give agents context on when to use project-specific MCP tools. If left empty, agents will infer tool purpose from names and descriptions.

| Tool Pattern | Purpose | When to use |
|:---|:---|:---|
| `radzen.mcp/*` | UI component library API | Verify component properties, events, usage patterns |
| `microsoftdocs/mcp/*` | Microsoft/.NET framework docs | Verify API signatures, framework conventions, lifecycle |

## Debugger Tier Scoping
> Used by triage and orchestrators to route bugs to the correct debugger.

| Tier | Agent | Scope |
|:---|:---|:---|
| 1 — Medic | `@debugger-medic` | Compiler/syntax/simple null-check issues |
| 2 — Detective | `@debugger-detective` | Blazor state/lifecycle/circuit/race-condition issues |
| 3 — Specialist | `@debugger-specialist` | EF Core/SQL/API routing/data-service issues |
| 4 — Forensic | `@debugger-forensic` | DI/architecture/memory-leak issues |
