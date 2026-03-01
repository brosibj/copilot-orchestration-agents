# Context & Constraints
- **Scope:** See `README.md` for tech stack/packages.
- **Rules:** No new `.md` files without explicit direction/approval. Validate all changes for regressions.
- **Tone:** Direct, technical, and concise. Challenge suboptimal architecture, decisions, and this prompt if appropriate.

# Technical Standards
- **Stack:** C# 14, .NET 10.0, Radzen UI.
- **Patterns:** DRY/ACID, SoC, SRP, DI (prefer over static/singletons). Use constants over magic values.
- **Handling:** Use `FluentResults.Result` for logic flow or for failures expected during normal operation; Exceptions only for technical failures (catch/log at top-level).
- **Quality:** Resolve all build warnings (run `dotnet build --no-incremental`). XML comments for public members; `// TODO:` for pending work.

# EF Core & Migrations
- **Clean History:** Determine from input if a new migration should be added or rolled back and re-added.
- **Command:** `dotnet ef database update <Prev>; dotnet ef migrations remove; dotnet ef migrations add <Name>; dotnet ef database update`

## DbContext Patterns
| Component Type | Pattern | Strategy |
| :--- | :--- | :--- |
| **Edit/Detail Pages** | `OwningComponentBase` | Scoped context, `ChangeTracker` for dirty state, Concurrency handling. |
| **Read/List/Services** | `IDbContextFactory` | Short-lived `await using`, `AsNoTracking()` for performance. |
| **Hybrid** | Mixed | `OwningComponentBase` for main entity; Services for lookups. |

# UI & Assets (Blazor/Radzen)
- **Style:** Modern/Mobile-friendly. Prioritize Radzen components over custom HTML/CSS. See `styleguide.md` for details.
- **Assets:** NO CSS/JS in `.razor` files. CSS: Codebehind css file for custom components, or `app.css` for global styles that apply to elements we don't own (`div`, `RadzenCard`, etc). JS: Use `wwwroot/`. Minimal JS & CSS only when mandatory.
- **Packages:** Always latest version, using `dotnet add package <PackageName>` only, do not modify the `.csproj` file directly for this. Get confirmation before adding new NuGet packages.

# Testing
See `.github/testing.md` for patterns, builders, anti-patterns, exclusions, and commands.
- **Framework:** xUnit 2.9.2+ with FluentAssertions and NSubstitute.
- **Projects:** `MediaLens.UnitTests` (fast, in-memory), `MediaLens.IntegrationTests` (SQLite, E2E).
- **Coverage:** All new services require unit tests. Complex workflows (GroupBy navigation, cascade deletes) need integration tests.
- **CI/CD:** `dotnet test` must pass (0 failures) before merge. Regressions always block; new failures require documented justification in `plan.md` under `## Known Test Limitations`.

# Agent Workflow

## Orchestrators (user-invokable)
| Phase | Agent | Purpose | Hands off to |
|:---|:---|:---|:---|
| 1 | `@research` | Discovery, requirements, technical research, planning | `@implement` |
| 2 | `@implement` | Implementation, migration, testing, validation, review | `@document` |
| 3 | `@document` | Documentation, deferred issue tracking, PR readme | — |

## Shared References
- **Dispatch rules:** `.github/agents/shared/dispatch-rules.md` — Opus constraints, parallel rules, artifact protocol.
- **Debugger workflow:** `.github/agents/shared/debugger-workflow.md` — common steps for all 4 debugger tiers.
- **Artifact templates:** `.github/agents/templates/` — `research.md`, `plan.md`, `report.md`, `readme.md`.

## Agent Standards
- All agents enforce this file, `styleguide.md`, and `testing.md` — do not duplicate their content.
- Missing artifact = failure (`Artifact Missing`).
- Opus agents are single-instance only. Non-Opus agents may run in parallel with non-overlapping scopes.
- Artifacts reference prior artifacts instead of restating content.

## Bug Debugging Tiers
| Tier | Model | Scope |
|:---|:---|:---|
| Medic | Haiku 4.5 | Compiler/syntax/null-check |
| Detective | Gemini 3.1 Pro | Blazor state/lifecycle/race-condition |
| Specialist | GPT-5.3 Codex | Backend/data/EF Core/API routing |
| Forensic | Claude Opus 4.6 | Architectural/DI/memory-leak |