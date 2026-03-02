# Context & Constraints
- **Scope:** See `README.md` at the repo root for tech stack/packages and agent workflow overview.
- **Rules:** No new `.md` files without explicit direction/approval. Validate all changes for regressions.
- **Tone:** Direct, technical, and concise. Challenge suboptimal architecture, decisions, and this prompt if appropriate. Prefer using `vscode/askQuestions` instead of ending the session.

# Technical Standards
- **Stack:** C# 14, .NET 10.0, Radzen UI.
- **Patterns:** DRY/ACID, SoC, SRP, DI (prefer over static/singletons). Use constants over magic values.
- **Handling:** Use `FluentResults.Result` for logic flow or for failures expected during normal operation; Exceptions only for technical failures (catch/log at top-level).
- **Quality:** Resolve all build warnings (run `dotnet build --no-incremental`). XML comments for public members; `// TODO:` for pending work including github issue number.

# EF Core & Migrations
- **Clean History:** Determine from input if a new migration should be added or rolled back and re-added.
- **Command:** `dotnet ef database update <Prev>; dotnet ef migrations remove; dotnet ef migrations add <Name>; dotnet ef database update`

# Project Reference Files
As needed, reference the following files for guidance on patterns, anti-patterns, and workarounds in `.github/docs/`:
- **Errata:** `.github/docs/errata/` for patterns, anti-patterns, and workarounds. Each file is scoped to a specific topic.
- **Style:** See `.github/docs/styleguide.md` for details.
- **Testing:** See `.github/docs/testing.md` for patterns, builders, anti-patterns, exclusions, and commands. Includes info for building tests as well as testing standards after implementing new features or bug fixes.

# Coding Standards
- **Assets:** NO CSS/JS in `.razor` files. 
  - **CSS:** Codebehind css file for custom components, or `app.css` for global styles that apply to elements we don't own (`div`, elements provided by packages, etc). 
  - **JS:** Use `wwwroot/`. Minimal JS & CSS only when mandatory.
- **Project Files:** Never create or modify `.csproj` files manually. Use `dotnet` CLI commands for all project operations (add/remove packages, add references, etc.). Manual `.csproj` edits are only permitted when no `dotnet` command exists for the required operation.
- **Packages:** Do not specify a version when adding packages — omitting the version pulls the latest (`dotnet add package <PackageName>`). Get confirmation (`vscode/askQuestions`) before adding new NuGet packages.

# Agent Workflow
All agents enforce this file and all `.github/docs/` files for project standards, patterns, and anti-patterns. Agents should read relevant `.md` files based on file name/topic.

## Orchestrators (user-invokable)
| Phase | Agent | Purpose | Hands off to |
|:---|:---|:---|:---|
| 1 | `@research` | Discovery, requirements, technical research, planning | `@implement` |
| 2 | `@implement` | Implementation, migration, testing, validation, review | `@document` |
| 3 | `@document` | Documentation, deferred issue tracking, PR readme | — |

## Shared References
- **Dispatch rules:** `.github/agents/shared/dispatch-rules.md` — constraints, parallel rules, artifact protocol.
- **Debugger workflow:** `.github/agents/shared/debugger-workflow.md` — common steps for all 4 debugger tiers.
- **Artifact templates:** `.github/agents/templates/` — `research.md`, `plan.md`, `report.md`, `readme.md`.
