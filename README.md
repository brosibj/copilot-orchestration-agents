# Copilot Orchestration Agents

A GitHub Copilot agent template for structured, multi-phase AI-driven development workflows. Designed to be kept current with evolving standards and adapted per project.

---

## Overview

This repository provides a complete set of GitHub Copilot Chat agent definitions (`.agent.md` files) that implement a repeatable development workflow:

```
@quick                                  ← simple tasks (single-pass)
@discover  →  @build  →  @finalize     ← standard tasks (multi-phase)
```

Each phase is an orchestrator that fans work out to focused sub-agents, enforces quality gates, and hands off structured artifacts to the next phase. Agents are model-assigned by task complexity, and validation is built into the loop rather than bolted on at the end. Orchestration agents invoke sub-agents for specific tasks to manage complexity and context window and ensure quality. When one orchestrator completes, it prompts for handoff to the next orchestrator with a structured artifact set.

Four orchestrators are user-invokable: `@quick` for simple tasks, and the `@discover` → `@build` → `@finalize` pipeline for standard tasks. Orchestrators do not specify a model — the user chooses based on the scope and size of the requested changes. All sub-agents are model-assigned and invoked by the orchestrators.

### Assumptions

The agent definitions statically reference the following packages and tools. Projects consuming this template should have these in place, or update the relevant agent/addendum files accordingly.

**Runtime & Framework**
| Package | Purpose |
|:---|:---|
| C# 14 / .NET 10.0 | Target language and runtime |
| ASP.NET Core Blazor | UI framework (Server or WebAssembly) |
| Radzen.Blazor | Component library — enforced by `styleguide.md` and `implementer-ui` |
| Microsoft.EntityFrameworkCore | ORM — migrations managed by `@migrator` |
| Microsoft.EntityFrameworkCore.Sqlite | Integration test database provider |
| FluentResults | `Result<T>` pattern for service logic flow |
| Hangfire (via `IBackgroundJobClient`) | Background job scheduling — referenced in test anti-patterns |

**Testing**
| Package | Purpose |
|:---|:---|
| xUnit | Test framework |
| FluentAssertions | Assertion library (replaces `xUnit Assert.*`) |
| NSubstitute | Mocking library (interfaces only) |

**MCP Tool Extensions (GitHub Copilot)**
| Tool | Used by |
|:---|:---|
| `radzen.mcp/*` | `@implementer-ui`, `@researcher`, `@research-worker`, `@validator`, `@reviewer` |
| `microsoftdocs/mcp/*` | `@researcher`, `@research-worker`, `@implementer`, `@implementer-ui`, `@implementer-service`, all debuggers |
| `github/*` | `@finalize`, `@quick`, `@deferred-tracker` |

---

## Workflow

### Quick Path — `@quick`

**Invoke with:** a description of the simple task, or `{task-slug}` if `@discover` already produced `research.md`.

Single-pass orchestrator for tasks that touch ≤ 3 files, require no schema changes, and need no new dependencies. Handles discovery, implementation, validation, and finalization in one invocation without dispatching heavyweight subagents.

**Output:** `plans/{task-slug}/research.md` and `plans/{task-slug}/README.md`. Optionally creates/updates a PR.

---

### Phase 1 — `@discover`

**Invoke with:** a description of the feature or bug.

Orchestrates discovery and planning:

1. **Complexity gate** — classifies the task as Simple or Standard. Simple tasks are directed to `@quick` after discovery.
2. **Requirements** — `@requirements-builder` formalizes intent and acceptance criteria.
3. **Investigation** — `@researcher` maps affected files, audits dependencies, and flags risks. `@research-worker` instances may be dispatched in parallel for targeted fact-finding across distinct topics.
4. **Bug triage** — `@triage` classifies bugs to the correct debugger tier (if applicable).
5. **Planning** (Standard only) — `@planner` produces a step-by-step plan with scope, sequencing, and test requirements.

**Output:** `plans/{task-slug}/research.md` and (for Standard tasks) `plans/{task-slug}/plan.md`.

---

### Phase 2 — `@build`

**Invoke with:** `{task-slug}` from `@discover`.

Orchestrates execution and validation:

1. **Migration** (if needed) — `@migrator` handles EF Core schema changes with clean history.
2. **Implementation** — routes to specialized implementers:
   - `.razor`/layout/component files → `@implementer-ui`
   - `.cs` service/repository/test files → `@implementer-service`
   - Mixed scope → `@implementer`
3. **Bug path** — dispatches the appropriate debugger tier per triage classification; auto-escalates if needed.
4. **Validation** — `@validator` (build, tests, requirements coverage) and `@reviewer` (code quality) run in parallel.

**Output:** `plans/{task-slug}/report.md`. Loops on failures before surfacing to user (max 2 retries).

---

### Phase 3 — `@finalize`

**Invoke with:** `{task-slug}` from `@build`.

Orchestrates finalization:

1. **Documentation** — `@documenter` updates `README.md` and `docs/` if behavior changed. Documentation effort is proportional to change size.
2. **Deferred tracking** — `@deferred-tracker` catalogs non-blocking issues as GitHub issues.
3. **PR readme** — creates `plans/{task-slug}/README.md` for the pull request.

---

## Subagent Model Assignments

| Agent | Model | Rationale |
|:---|:---|:---|
| `requirements-builder` | Claude Opus | Ambiguity resolution, structured requirements |
| `researcher` | Gemini Pro | Broad codebase exploration, dep audits |
| `research-worker` | Haiku / Flash | Lightweight parallel fact-finding |
| `triage` | Haiku / Flash | Initial identification of issues and classification |
| `planner` | Claude Opus | Architecture decisions, plan correctness |
| `migrator` | GPT Codex | Precise migration generation |
| `implementer` | Claude Sonnet | Code generation |
| `implementer-ui` | Claude Sonnet | UI/component generation |
| `implementer-service` | GPT Codex | Service/backend generation |
| `debugger-medic` | Haiku / Flash | Quick issue identification and resolution |
| `debugger-detective` | Gemini Pro | Blazor lifecycle/state reasoning |
| `debugger-specialist` | GPT Codex | EF Core/SQL/API diagnosis |
| `debugger-forensic` | Claude Opus | Architectural root-cause analysis |
| `validator` | Claude Sonnet | Build, test, coverage verification |
| `deferred-tracker` | Haiku / Flash | Low-cost classification and tracking |
| `documenter` | Codex-Mini / Flash | Lightweight documentation, proportional to change size |
| `reviewer` | Claude Opus | Deep code quality judgment |

> Models chosen for each role based on strengths of the model. Agents are updated with fallback models in each agent file as new versions become available and in the case of rate-limiting.

---

## Artifact Protocol

All artifacts live under `plans/{task-slug}/`. Only `README.md` in each `task-slug` directory is committed to avoid excessive noise in the repo. All other artifacts are treated as ephemeral and are not committed. Agents reference prior artifacts rather than restating their content.

| File | Produced by | Consumed by |
|:---|:---|:---|
| `research.md` | `@discover` (or `@quick`) | `@build`, `@finalize` |
| `plan.md` | `@discover` | `@build`, `@finalize` |
| `report.md` | `@build` | `@finalize` |
| `diagnosis.md` | debuggers | `@build` |
| `README.md` | `@finalize` (or `@quick`) | Pull request |

A missing expected artifact is a hard failure (`Artifact Missing`). Agents reference prior artifacts rather than restating their content.

---

## Bug Debugging Tiers

| Tier | Agent | Scope | Budget |
|:---|:---|:---|:---|
| 1 | `@debugger-medic` | Compiler/syntax/null | 2 passes |
| 2 | `@debugger-detective` | Blazor state/lifecycle/race | 3 passes |
| 3 | `@debugger-specialist` | EF Core/SQL/API routing | 3 passes |
| 4 | `@debugger-forensic` | DI/architecture/memory-leak | 5 passes |

Triage (`@triage`) selects the lowest-cost appropriate tier. If a tier exceeds its iteration budget without progress, it returns an escalation signal to the orchestrator.

---

## Adapting This Template

### Per-project customization

| File | What to customize |
|:---|:---|
| `.github/copilot-instructions.md` | Tech stack, .NET version, framework-specific patterns |
| `.github/docs/styleguide.md` | UI library, component conventions, CSS approach |
| `.github/docs/testing.md` | Test project names (`<ProjectName>.UnitTests`), builders, exclusions |

Replace `<ProjectName>` placeholders throughout templates with the actual project name once a project uses this template.

### Adding new addendums

Place additional reference files in `.github/docs/` and reference them from the relevant agent files by full path (e.g., `.github/docs/my-guide.md`).

### Non-Blazor projects

- Remove or replace `.github/docs/errata/blazor-js-interop-disposal.errata.md` and `styleguide.md`.
- Update `implementer-ui.agent.md` tool list and rules for the target UI framework.
- Update debugger-detective scope if not using Blazor.

---

## Standards Enforced by All Agents

- `.github/copilot-instructions.md` — technical standards, patterns, error handling.
- `.github/docs/styleguide.md` — UI/Radzen conventions.
- `.github/docs/testing.md` — test patterns, builders, anti-patterns.
- `dotnet build --no-incremental` — 0 errors, 0 warnings before any handoff.
- `dotnet test` — 0 failures before merge. Regressions always block.
