# Coding Suite

This document covers the coding suite authored under `suites/coding/`.

The coding workflow shares the global baseline authored in `suites/copilot-instructions.md`. Coding-specific orchestration behavior lives in `suites/coding/agents/shared/workflow-rules.md`.

## Overview

The coding workflow implements a repeatable multi-phase development flow:

```text
@quick                                  ← simple tasks (single-pass)
@discover  →  @build  →  @finalize     ← standard tasks (multi-phase)
```

Each phase is an orchestrator that fans work out to focused sub-agents, enforces quality gates, and hands off structured artifacts to the next phase. Orchestrators are lean coordinators and route decisions through concise subagent summaries.

## What It Is For

- source-code implementation
- bug investigation and repair
- schema and migration work
- compile/test validation
- code review and PR-ready closure

## Features

- consistent multi-phase development flow
- right-sized model usage per role
- parallel execution for research and validation
- structured artifacts for traceability
- history-based doc refresh support
- context-aware UI validation
- standards enforcement through auto-loaded instructions
- regression-test-first debugger flow

## Getting Started

### 1. Run `/align-project`

Use the coding suite setup prompt to gather project facts and align the active instruction files to the current repo state.

### 2. Populate active instruction files

`/align-project` creates or updates these in `.github/instructions/` from templates in `.github/agents/templates/`:

| Priority | File | What to customize |
|:---|:---|:---|
| **Always** | `instructions/project.instructions.md` | Tech stack, build/migration commands, error handling, coding standards, data access patterns, MCP tool guidance, debugger tier scoping |
| **If UI** | `instructions/styleguide.instructions.md` | UI library, component conventions, component data access patterns, CSS approach |
| **If tests** | `instructions/testing.instructions.md` | Test framework, test commands, project names, assertion libraries, builders, anti-patterns |

### 3. Update MCP tools when needed

If your project uses different MCP tool extensions, update the `tools:` lists in the affected agent frontmatter.

### 4. Add suite-local instructions or skills when needed

Add focused instruction files or suite-local skills only when the coding workflow needs them.

## Orchestrators

### Quick Path — `@quick`

Invoke with a simple task description, or a `{task-slug}` if `@discover` already produced `research.md`.

Single-pass orchestrator for tasks that touch at most three files, require no schema changes, and need no new dependencies.

### Phase 1 — `@discover`

Discovery and planning orchestrator.

1. `@requirements-builder` formalizes intent and returns a complexity classification.
2. `@triage` classifies bug work to the appropriate debugger tier when needed.
3. Simple tasks hand off to `@quick`.
4. Standard tasks fan out parallel `@researcher` runs and then compile findings into `research.md`.
5. `@planner` produces `plan.md` for reviewed execution.

### Phase 2 — `@build`

Execution and validation orchestrator.

1. Uses `@researcher` for pre-flight routing.
2. Invokes `@migrator` when schema changes are required.
3. Routes implementation to the relevant implementer or debugger tier.
4. Runs `@validator` and `@reviewer` in parallel, then writes `report.md`.

### Phase 3 — `@finalize`

Closure orchestrator.

1. `@documenter` updates docs when behavior changed.
2. `@deferred-tracker` captures non-blocking follow-up work.
3. Produces `pr.md` and supports PR creation or update.

## Subagent Model Assignments

| Agent | Role | Model | Rationale |
|:---|:---|:---|:---|
| `requirements-builder` | Discovery | Claude Opus | Ambiguity resolution, structured requirements |
| `researcher` | Discovery / Utility | GPT-5.4 | Generic scoped analysis, parallel fact-finding, artifact compilation |
| `triage` | Discovery | Haiku / Flash | Initial identification of issues and classification |
| `planner` | Planning | Claude Opus | Architecture decisions, plan correctness |
| `migrator` | Execution | GPT Codex | Precise migration generation |
| `implementer` | Execution | Claude Sonnet | Mixed-scope code generation |
| `implementer-ui` | Execution | Claude Sonnet | UI/component generation |
| `implementer-service` | Execution | GPT-5.4 | Service/backend generation |
| `debugger-medic` | Debugging | Haiku / Flash | Quick issue identification and resolution |
| `debugger-detective` | Debugging | Gemini Pro | UI framework lifecycle/state reasoning |
| `debugger-specialist` | Debugging | GPT-5.4 | Data/ORM/API diagnosis |
| `debugger-forensic` | Debugging | Claude Opus | Architectural root-cause analysis |
| `validator` | Validation | Claude Sonnet | Build, test, coverage verification |
| `reviewer` | Validation | Claude Opus | Deep code quality judgment |
| `deferred-tracker` | Finalization | Haiku / Flash | Low-cost classification and tracking |
| `documenter` | Finalization | GPT-5.4 | Lightweight documentation, proportional to change size |

## Bug Debugging Tiers

| Tier | Agent | Scope | Budget |
|:---|:---|:---|:---|
| 1 | `@debugger-medic` | Compiler/syntax/null | 2 passes |
| 2 | `@debugger-detective` | UI framework state/lifecycle/race | 3 passes |
| 3 | `@debugger-specialist` | Data/ORM/API routing | 3 passes |
| 4 | `@debugger-forensic` | DI/architecture/memory-leak | 5 passes |

## Artifact Protocol

All coding workflow artifacts live under `plans/{task-slug}/`.

| File | Produced by | Consumed by |
|:---|:---|:---|
| `research.md` | `@discover` or `@quick` | `@build`, `@finalize` |
| `fragments/*.md` | `@researcher` instances | `@researcher` compile pass |
| `plan.md` | `@discover` | `@build`, `@finalize` |
| `report.md` | `@build` | `@finalize` |
| `diagnosis.md` | debugger tiers | `@build` |
| `pr.md` | `@finalize` or `@quick` | pull request |

## Coding Suite Structure

```text
suites/
├── copilot-instructions.md
└── coding/
    ├── agents/
    │   ├── *.agent.md
    │   ├── shared/
    │   └── templates/
    ├── instructions/
    ├── prompts/
    └── skills/
```
