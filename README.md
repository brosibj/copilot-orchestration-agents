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

---

## Features

### What it helps with:
- **Consistent, repeatable development** — the same planning, implementation, validation, and documentation steps are enforced on every task, regardless of who invokes them.
- **Right-sized model usage** — expensive reasoning models handle architecture and ambiguity; cheap, fast models handle narrow, well-scoped tasks like triage and classification.
- **Parallel execution** — independent sub-agents (research workers, validator + reviewer) run concurrently, reducing total wall-clock time per task.
- **Structured artifact trail** — every task produces `research.md`, `plan.md`, `report.md`, and a PR `README.md`, making decisions traceable.
- **Standards enforcement** — all agents read the same shared reference files, so code style, test patterns, error handling, and UI conventions are applied uniformly.

### What it helps prevent:
- **Context window overload** — orchestrators fan work out to focused sub-agents rather than loading everything into one long session.
- **Skipped steps** — validation, testing, and code review are wired into the loop; they cannot be bypassed without the orchestrator failing its output check.
- **Regressions** — all debuggers are required to write a failing regression test before applying a fix.
- **Deferred work going untracked** — `@deferred-tracker` catalogs non-blocking issues as GitHub issues before the task closes.
- **Scope creep** — the complexity gate routes simple tasks to `@quick`, preventing heavyweight phases from being invoked unnecessarily.

### Adapt for your project:
- All project-specific settings are consolidated in `.github/docs/` — primarily `project.md`, `styleguide.md`, and `testing.md`. No agent files need editing.
- Projects using different UI frameworks should replace `styleguide.md` and the errata files.
- Projects using different ORMs, test frameworks, or job schedulers should update the relevant docs.


### Assumptions

In order to adequately enforce the agent definitions, the following packages and tools are statically referenced. Projects consuming this template should have these in place, or update the relevant docs accordingly.

**Runtime & Framework**
| Package | Purpose | Defined in |
|:---|:---|:---|
| C# 14 / .NET 10.0 | Target language and runtime | `project.md` |
| ASP.NET Core Blazor | UI framework (Server or WebAssembly) | `project.md`, `styleguide.md`, `errata/blazor-js-interop-disposal.errata.md` |
| Radzen.Blazor | Component library | `project.md`, `styleguide.md` |
| Microsoft.EntityFrameworkCore | ORM — migrations managed by `@migrator` | `project.md` |
| Microsoft.EntityFrameworkCore.Sqlite | Integration test database provider | `project.md`, `testing.md` |
| FluentResults | `Result<T>` pattern for service logic flow | `project.md` |
| Hangfire (via `IBackgroundJobClient`) | Background job scheduling — referenced in test anti-patterns | `project.md`, `testing.md` |

**Testing**
| Package | Purpose | Defined in |
|:---|:---|:---|
| xUnit | Test framework | `testing.md` |
| FluentAssertions | Assertion library (replaces `xUnit Assert.*`) | `testing.md` |
| NSubstitute | Mocking library (interfaces only) | `testing.md` |

**MCP Tool Extensions (GitHub Copilot)**
| Tool | Used by | Referenced in |
|:---|:---|:---|
| `radzen.mcp/*` | `@implementer`, `@implementer-ui`, `@researcher`, `@research-worker`, `@validator`, `@reviewer` | `implementer.agent.md`, `implementer-ui.agent.md`, `researcher.agent.md`, `research-worker.agent.md`, `validator.agent.md`, `reviewer.agent.md` |
| `microsoftdocs/mcp/*` | `@researcher`, `@research-worker`, `@implementer`, `@implementer-ui`, `@implementer-service`, `@validator`, `@reviewer`, all debuggers | `researcher.agent.md`, `research-worker.agent.md`, `implementer.agent.md`, `implementer-ui.agent.md`, `implementer-service.agent.md`, `validator.agent.md`, `reviewer.agent.md`, `debugger-*.agent.md` |
| `github/*` | `@finalize`, `@quick`, `@deferred-tracker`, `@researcher`, `@requirements-builder` | `P3-finalize.agent.md`, `quick.agent.md`, `deferred-tracker.agent.md`, `researcher.agent.md`, `requirements-builder.agent.md` |

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
3. **Investigation** — `@researcher` maps affected files, audits dependencies, and flags risks. Researcher dispatches `@research-worker` instances in parallel for targeted fact-finding across distinct topics.
4. **Bug triage** — `@triage` classifies bugs to the correct debugger tier (if applicable).
5. **Planning** (Standard only) — `@planner` produces a step-by-step plan with scope, sequencing, and test requirements.

**Output:** `plans/{task-slug}/research.md` and (for Standard tasks) `plans/{task-slug}/plan.md`.

---

### Phase 2 — `@build`

**Invoke with:** `{task-slug}` from `@discover`.

Orchestrates execution and validation:

1. **Migration** (if needed) — `@migrator` handles schema changes with clean history.
2. **Implementation** — routes to specialized implementers:
   - `.razor`/layout/component files → `@implementer-ui`
   - `.cs` service/repository/test files → `@implementer-service`
   - Mixed scope → `@implementer`
3. **Bug path** — dispatches the appropriate debugger tier per triage classification; auto-escalates if needed.
4. **Validation** — `@validator` (build, tests, requirements coverage) and `@reviewer` (code quality) run in parallel, each returning findings to the orchestrator. The orchestrator merges results and writes `report.md`.

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
| `debugger-detective` | Gemini Pro | UI framework lifecycle/state reasoning |
| `debugger-specialist` | GPT Codex | ORM/SQL/API diagnosis |
| `debugger-forensic` | Claude Opus | Architectural root-cause analysis |
| `validator` | Claude Sonnet | Build, test, coverage verification |
| `deferred-tracker` | Haiku / Flash | Low-cost classification and tracking |
| `documenter` | Codex-Mini / Flash | Lightweight documentation, proportional to change size |
| `reviewer` | Claude Opus | Deep code quality judgment |

> Models chosen for each role based on strengths of the model. Agents are updated with fallback models in each agent file as new versions become available and in the case of rate-limiting.

---

## Artifact Protocol

All artifacts live under `plans/{task-slug}/`. It is recommended that only `README.md` in each `task-slug` directory is committed to avoid excessive noise in the repo (see this repo's `.gitignore`). All other artifacts are treated as ephemeral and are not committed. Agents reference prior artifacts rather than restating their content, to enforce full context, and allow for idempotent restarts.

| File | Produced by | Consumed by |
|:---|:---|:---|
| `research.md` | `@discover` (or `@quick`) | `@build`, `@finalize` |
| `plan.md` | `@discover` | `@build`, `@finalize` |
| `report.md` | `@build` | `@finalize` |
| `diagnosis.md` | debuggers | `@build` |
| `README.md` | `@finalize` (or `@quick`) | Pull request |

A missing expected artifact is considered a hard failure. Orchestrators will retry once before surfacing the failure to the user.

---

## Bug Debugging Tiers

| Tier | Agent | Scope | Budget |
|:---|:---|:---|:---|
| 1 | `@debugger-medic` | Compiler/syntax/null | 2 passes |
| 2 | `@debugger-detective` | UI framework state/lifecycle/race | 3 passes |
| 3 | `@debugger-specialist` | ORM/SQL/API routing | 3 passes |
| 4 | `@debugger-forensic` | DI/architecture/memory-leak | 5 passes |

Triage (`@triage`) selects the lowest-cost appropriate tier. If a tier exceeds its iteration budget without progress, it returns an escalation signal to the orchestrator. All debugger tiers write a regression test before applying the fix.

---

## Adapting This Template

Agent files are project-agnostic — all project-specific settings live in `.github/docs/`. To adapt this template for your project, update the docs below. No agent files need editing.

### Files to update

| Priority | File | What to customize |
|:---|:---|:---|
| **Always** | `.github/docs/project.md` | Tech stack, build/test/migration commands, error handling, coding standards, data access patterns, debugger tier scoping |
| **If UI** | `.github/docs/styleguide.md` | UI library, component conventions, component data access patterns, CSS approach |
| **If tests** | `.github/docs/testing.md` | Test framework, project names (`<ProjectName>.UnitTests`), builders, anti-patterns |
| **As needed** | `.github/docs/errata/` | Add/remove framework-specific patterns and anti-patterns |

> `<ProjectName>` placeholders can be left alone — agents will infer the project name from context.

### Adding new reference docs

Place additional reference files in `.github/docs/` and add them to the Docs Index in `.github/copilot-instructions.md`. Reference them in the **Required References** section of relevant agent files.

### Non-Blazor projects

1. Update `.github/docs/project.md` — change stack, packages, build commands, data access patterns, debugger tier scoping.
2. Replace `.github/docs/styleguide.md` with conventions for your UI framework.
3. Remove or replace `.github/docs/errata/blazor-js-interop-disposal.errata.md`.
4. Update `.github/docs/testing.md` if using a different test framework.

---

## Standards Enforced by All Agents

- `.github/copilot-instructions.md` — auto-loaded baseline: tone, workflow overview, Docs Index.
- `.github/agents/shared/workflow-rules.md` — coordination, parallel dispatch, iteration, artifacts, failure handling.
- Each agent enforces the project docs listed in its **Required References** section.
- Build and test gates are defined in `.github/docs/project.md` § Build & Validation.
