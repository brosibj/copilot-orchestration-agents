# Copilot Orchestration Agents

A GitHub Copilot agent template for structured, multi-phase AI-driven development workflows. Designed to be adapted per project.


## Overview

This repository provides a complete set of GitHub Copilot Chat agent definitions (`.agent.md` files) that implement a repeatable development workflow:

```
@quick                                  ← simple tasks (single-pass)
@discover  →  @build  →  @finalize     ← standard tasks (multi-phase)
```

Each phase is an orchestrator that fans work out to focused sub-agents, enforces quality gates, and hands off structured artifacts to the next phase. Agents are model-assigned by task complexity, and validation is built into the loop rather than bolted on at the end. Orchestrators are lean coordinators — they do not read file contents, relying instead on concise subagent return summaries for routing decisions (`@quick` is the exception as a hybrid worker). When one orchestrator completes, it prompts for handoff to the next orchestrator with a structured artifact set.

Four orchestrators are user-invokable: `@quick` for simple tasks, and the `@discover` → `@build` → `@finalize` pipeline for standard tasks. Orchestrators do not specify a model — the user chooses based on the scope and size of the requested changes. All sub-agents are model-assigned and invoked by the orchestrators.


## Features

### What it helps with:
- **Consistent, repeatable development** — the same planning, implementation, validation, and documentation steps are enforced on every task, regardless of who invokes them.
- **Right-sized model usage** — slower reasoning models handle architecture and ambiguity; faster models handle narrow, well-scoped tasks like triage and classification.
- **Parallel execution** — independent sub-agents (research workers, validator + reviewer) run concurrently, reducing total wall-clock time per task.
- **Structured artifact trail** — every task produces `research.md`, `plan.md`, `report.md`, and `pr.md`, making decisions traceable.
- **Standards enforcement** — all agents read the same shared reference files, so code style, test patterns, error handling, and UI conventions are applied uniformly.

### What it helps prevent:
- **Context window management** — orchestrators are lean coordinators that do not read file contents. All analysis is delegated to subagents, which return concise structured summaries. This prevents context bloat in the orchestrator.
- **Skipped steps** — validation, testing, and code review are wired into the loop; they cannot be bypassed without the orchestrator failing its output check.
- **Regressions** — all debuggers are required to write a failing regression test before applying a fix.
- **Deferred work going untracked** — `@deferred-tracker` catalogs non-blocking issues as GitHub issues before the task closes.
- **Scope creep** — the complexity gate routes simple tasks to `@quick`, preventing heavyweight phases from being invoked unnecessarily.


## Workflow

### Quick Path — `@quick`

**Invoke with:** a description of the simple task, or `{task-slug}` if `@discover` already produced `research.md`.

Single-pass orchestrator for tasks that touch ≤ 3 files, require no schema changes, and need no new dependencies. Handles discovery, implementation, validation, and finalization in one invocation without dispatching heavyweight subagents.

**Output:** `plans/{task-slug}/research.md` and `plans/{task-slug}/pr.md`. Optionally creates/updates a PR.


### Phase 1 — `@discover`

**Invoke with:** a description of the feature or bug.

Orchestrates discovery and planning:

1. **Complexity gate** — classifies the task as Simple or Standard. Simple tasks are directed to `@quick` after discovery.
2. **Requirements** — `@requirements-builder` formalizes intent, acceptance criteria, and suggests research scopes.
3. **Parallel research** — The orchestrator dispatches multiple `@researcher` instances in parallel (one per scope from requirements). Each writes a fragment file. A final `@researcher` compile pass merges fragments into `research.md`.
4. **Bug triage** — `@triage` classifies bugs to the correct debugger tier (if applicable).
5. **Planning** (Standard only) — `@planner` produces a step-by-step plan with scope, sequencing, and test requirements.

**Output:** `plans/{task-slug}/research.md` and (for Standard tasks) `plans/{task-slug}/plan.md`.


### Phase 2 — `@build`

**Invoke with:** `{task-slug}` from `@discover`.

Orchestrates execution and validation:

1. **Pre-flight** — dispatches `@researcher` to summarize `plan.md` and return routing info (schema changes, step order, task type).
2. **Migration** (if needed) — `@migrator` handles schema changes with clean history.
3. **Implementation** — routes to specialized implementers by file scope (UI, service/backend, or mixed).
3. **Bug path** — dispatches the appropriate debugger tier per triage classification; auto-escalates if needed.
4. **Validation** — `@validator` (build, tests, requirements coverage) and `@reviewer` (code quality) run in parallel, each returning findings to the orchestrator. The orchestrator merges results and writes `report.md`.

**Output:** `plans/{task-slug}/report.md`. Loops on failures before surfacing to user (max 2 retries).


### Phase 3 — `@finalize`

**Invoke with:** `{task-slug}` from `@build`.

Orchestrates finalization:

1. **Documentation** — `@documenter` updates project `README.md` and `docs/` if behavior changed. Documentation effort is proportional to change size.
2. **Deferred tracking** — `@deferred-tracker` catalogs non-blocking issues. The orchestrator prompts the user to approve which items become GitHub issues (multi-select, batched).
3. **PR description** — `@deferred-tracker` writes `plans/{task-slug}/pr.md` scaled to change size. The orchestrator asks the user: Create new PR / Update existing / Skip.


## Subagent Model Assignments

| Agent | Role | Model | Rationale |
|:---|:---|:---|:---|
| `requirements-builder` | Discovery | Claude Opus | Ambiguity resolution, structured requirements |
| `researcher` | Discovery / Utility | Gemini Pro | Generic scoped analysis, parallel fact-finding, artifact compilation |
| `triage` | Discovery | Haiku / Flash | Initial identification of issues and classification |
| `planner` | Planning | Claude Opus | Architecture decisions, plan correctness |
| `migrator` | Execution | GPT Codex | Precise migration generation |
| `implementer` | Execution | Claude Sonnet | Mixed-scope code generation |
| `implementer-ui` | Execution | Claude Sonnet | UI/component generation |
| `implementer-service` | Execution | GPT Codex | Service/backend generation |
| `debugger-medic` | Debugging | Haiku / Flash | Quick issue identification and resolution |
| `debugger-detective` | Debugging | Gemini Pro | UI framework lifecycle/state reasoning |
| `debugger-specialist` | Debugging | GPT Codex | Data/ORM/API diagnosis |
| `debugger-forensic` | Debugging | Claude Opus | Architectural root-cause analysis |
| `validator` | Validation | Claude Sonnet | Build, test, coverage verification |
| `reviewer` | Validation | Claude Opus | Deep code quality judgment |
| `deferred-tracker` | Finalization | Haiku / Flash | Low-cost classification and tracking |
| `documenter` | Finalization | Codex-Mini / Flash | Lightweight documentation, proportional to change size |

> [!NOTE]
> Models chosen for each role based on strengths of the model. Each agent file lists primary + fallback models for rate-limiting resilience.

> [!TIP]
> The orchestrators are model-agnostic. The user chooses the model for each phase based on task complexity and size. Sub-agents are model-assigned to ensure the right model is used for each role. If a subagent defines a model with a higher multiplier cost than what is used for the orchestrator, the subagent will use the model chosen for the orchestrator instead of its default model. This is intended [functionality built into GitHub Copilot itself](https://github.com/microsoft/vscode/issues/295449#issuecomment-3979023134).

## Bug Debugging Tiers

| Tier | Agent | Scope | Budget |
|:---|:---|:---|:---|
| 1 | `@debugger-medic` | Compiler/syntax/null | 2 passes |
| 2 | `@debugger-detective` | UI framework state/lifecycle/race | 3 passes |
| 3 | `@debugger-specialist` | Data/ORM/API routing | 3 passes |
| 4 | `@debugger-forensic` | DI/architecture/memory-leak | 5 passes |

Triage (`@triage`) selects the lowest-cost appropriate tier. Debugger tier scoping is defined in `project.md` so it can be customized per project. If a tier exceeds its budget, it returns an escalation signal to the orchestrator. All debugger tiers write a regression test before applying the fix.


## Artifact Protocol

All artifacts live under `plans/{task-slug}/`. It is recommended that only `pr.md` in each `task-slug` directory is committed to avoid excessive noise in the repo (see this repo's `.gitignore`). All other artifacts are treated as ephemeral and are not committed. Agents reference prior artifacts rather than restating their content, to enforce full context, and allow for idempotent restarts.

| File | Produced by | Consumed by |
|:---|:---|:---|
| `research.md` | `@discover` (or `@quick`) | `@build`, `@finalize` |
| `fragments/*.md` | `@researcher` instances | `@researcher` (compile pass) |
| `plan.md` | `@discover` | `@build`, `@finalize` |
| `report.md` | `@build` | `@finalize` |
| `diagnosis.md` | debuggers | `@build` |
| `pr.md` | `@finalize` (or `@quick`) | Pull request |

A missing expected artifact is considered a hard failure. Orchestrators will retry once before surfacing the failure to the user.


## Repository Structure

```
.github/
├── copilot-instructions.md          # Auto-loaded baseline: tone, Docs Index, workflow overview
├── agents/
│   ├── *.agent.md                   # Agent definitions (project-agnostic)
│   ├── shared/
│   │   ├── workflow-rules.md        # Coordination, parallel dispatch, iteration, artifacts
│   │   └── debugger-workflow.md     # Shared debugger execution steps
│   └── templates/
│       ├── research.md              # Discovery artifact template
│       ├── plan.md                  # Planning artifact template
│       ├── report.md                # Validation artifact template
│       └── pr.md                   # PR description artifact template
└── docs/
    ├── project.md                   # Stack, build commands, coding standards, data access
    ├── styleguide.md                # UI framework conventions, component patterns, CSS
    ├── testing.md                   # Test framework, test commands, patterns, builders, anti-patterns
    └── errata/                      # Framework-specific patterns & anti-patterns
```

### What lives where

| Layer | Files | Purpose | Who customizes |
|:---|:---|:---|:---|
| **Baseline** | `copilot-instructions.md` | Auto-loaded by all Copilot interactions. Tone, Docs Index, workflow overview. | Rarely — template maintainers only |
| **Agent workflow** | `agents/*.agent.md`, `agents/shared/` | Project-agnostic orchestration and execution logic. | Rarely — only MCP tool frontmatter when swapping tools |
| **Project docs** | `docs/project.md`, `docs/styleguide.md`, `docs/testing.md`, `docs/errata/` | All project-specific standards, conventions, and commands. | Always — this is what you customize for your project |


## Adapting This Template

Agent files are project-agnostic — all project-specific settings live in `.github/docs/`. To adapt this template:

### 1. Update project docs

| Priority | File | What to customize |
|:---|:---|:---|
| **Always** | `project.md` | Tech stack, build/migration commands, error handling, coding standards, data access patterns, MCP tool guidance, debugger tier scoping |
| **If UI** | `styleguide.md` | UI library, component conventions, component data access patterns, CSS approach |
| **If tests** | `testing.md` | Test framework, test commands, project names, assertion libraries, builders, anti-patterns |
| **As needed** | `errata/` | Add/remove framework-specific patterns and anti-patterns |

### 2. Update MCP tools (if applicable)

If your project uses different MCP tool extensions (e.g., replacing `radzen.mcp/*` with a different UI library's MCP), update the `tools:` list in the frontmatter of affected agent files. Agents infer tool purpose from names and descriptions, so no instruction text changes are needed — only the frontmatter `tools:` arrays.

### 3. Adding new reference docs

Place additional reference files in `.github/docs/` and add them to the Docs Index in `.github/copilot-instructions.md`. Reference them in the **Required References** section of relevant agent files.


## Standards Enforcement

| Layer | What | Loaded by |
|:---|:---|:---|
| `copilot-instructions.md` | Tone, Docs Index, workflow overview | Auto-loaded for all Copilot interactions |
| `workflow-rules.md` | Coordination, parallel dispatch, iteration, artifacts, verification, failure handling | All orchestrators and sub-agents |
| Per-agent **Required References** | Project docs relevant to each agent's role | Each agent loads only what it needs |
| `project.md` § Build & Validation | Build commands associated with gates | Implementers, debuggers, validator, quick |
| `testing.md` § Build & Test Commands | Test commands and gates | Implementers, debuggers, validator, quick |
