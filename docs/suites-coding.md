# Coding Suite

This document covers the coding suite authored under `suites/coding/`.

The coding suite is now prompt-and-skill first. It keeps users on the model they already selected in VS Code, uses prompt files for guided entry, and stores reusable workflow behavior plus templates inside skills.

## Overview

Use the guided prompts when you want structured intake, or invoke the skills directly when you already know which workflow phase you need.

```text
/align-project   -> repo context onboarding
/new-feature    -> /discover-plan -> /execute-plan -> /finalize-task
/bug-report     -> /discover-plan -> /execute-plan -> /finalize-task
/quick-fix      -> single-pass path using planning support + /execute-plan + /finalize-task

/discover-plan  -> planning phase prompt
/execute-plan   -> implementation phase prompt
/finalize-task  -> wrap-up phase prompt
```

## Customization Strategy

- `.github/copilot-instructions.md` stays short and always-on.
- `.github/instructions/**/*.instructions.md` carries scoped repo, language, framework, and domain rules.
- `.github/prompts/` provides the guided, user-facing entry points.
- `.github/skills/` owns reusable workflow behavior, adjacent resources, and all templates.
- Custom agents are not required for the coding suite.

## What It Is For

- source-code implementation
- feature, enhancement, and refactor planning
- bug investigation and repair
- schema and migration work
- compile, test, and browser validation
- documentation refresh and PR-ready closure

## Getting Started

### 1. Run `/align-project`

Use `/align-project` to gather project facts and create or refresh the repo-local context files that VS Code loads automatically.

### 2. Keep repo context layered correctly

`/align-project` creates or updates these from templates in `.github/skills/project-context-onboarding/templates/`:

| Priority | File | What it owns |
|:---|:---|:---|
| **Always** | `copilot-instructions.md` | Short, always-on repo context only |
| **Always** | `instructions/project.instructions.md` | Stack, workspace layout, commands, architecture boundaries, coding standards |
| **If UI** | `instructions/styleguide.instructions.md` | UI framework, component conventions, styling, accessibility |
| **If tests** | `instructions/testing.instructions.md` | Test framework, commands, fixtures, patterns, anti-patterns |
| **As needed** | `instructions/<domain>/*.instructions.md` | Focused rules for API, data, scripts, migrations, e2e tests, or other scoped areas |

### 3. Pick an entry style

- Use prompts when you want the suite to ask for missing information first.
- Use workflow skills when you already know the task and want to run the flow directly.
- Use phase skills when you want manual control over planning, implementation, validation, or finalization.
- Planning skills can start from a task title or an existing `plans/{task-slug}` path. Downstream skills should be given `plans/{task-slug}` so they stay scoped to the right artifact folder.

## User-Facing Entry Points

### Guided prompts

| Prompt | Use when |
|:---|:---|
| `/align-project` | onboarding or refreshing repo context |
| `/new-feature` | gathering structured feature details before running the workflow |
| `/bug-report` | gathering structured bug details before running the workflow |
| `/quick-fix` | confirming a task is small enough for the single-pass path |
| `/discover-plan` | you already know the task and want to produce `research.md` and `plan.md` |
| `/execute-plan` | planning is complete and the code change should be executed |
| `/finalize-task` | implementation and validation are done and the task is ready for docs and `pr.md` |

### Reusable skills

| Skill | Use when |
|:---|:---|
| `/capture-requirements` | you want to update only the intent sections of `research.md` |
| `/analyze-codebase` | you want to update only the technical-analysis portions of `research.md` |
| `/write-plan` | you want to regenerate or tighten `plan.md` from finished research |
| `/bug-triage` | you want only the bug-tier classification |
| `/apply-migration` | you want to run or verify migration work only |
| `/record-diagnosis` | you want to refresh `diagnosis.md` for a bug fix |
| `/validation-review` | you want to refresh `report.md` or rerun verification |
| `/refresh-docs` | you want only the documentation pass |
| `/prepare-pr` | you want only deferred-item handling and `pr.md` generation |

## Supporting Skills

| Skill | Purpose |
|:---|:---|
| `artifact-management` | task workspace bootstrap, fragments, and artifact conventions |
| `capture-requirements` | requirement and acceptance-criteria capture inside planning |
| `analyze-codebase` | technical analysis, findings, risks, and build baseline inside planning |
| `write-plan` | durable plan generation from completed research |
| `bug-triage` | bug investigation tiering |
| `apply-migration` | migration execution and verification |
| `record-diagnosis` | durable bug-fix diagnosis artifact generation |
| `dependency-audit` | deciding whether a new package is justified |
| `refresh-docs` | proportional documentation updates during finalization |
| `prepare-pr` | deferred issue handling plus `pr.md` generation |
| `project-context-onboarding` | repo context file generation |
| `update-docs-from-history` | syncing docs from recent git history when needed |
| `blazor-js-interop-disposal` | optional framework-specific disposal guidance |

## Artifact Protocol

All coding workflow artifacts live under `plans/{task-slug}/`.

`artifact-management` bootstraps the task workspace first: it normalizes the slug, ensures `plans/{task-slug}/` exists, and creates `fragments/` only when a workflow actually fans out. The skill that owns a template creates the corresponding missing file.

| File | Created by | Template owner |
|:---|:---|:---|
| `research.md` | planning prompts using `capture-requirements` and `analyze-codebase` | `capture-requirements` |
| `plan.md` | planning prompts using `write-plan` | `write-plan` |
| `fragments/*.md` | research-heavy planning flows when useful | `artifact-management` (no template) |
| `diagnosis.md` | execution prompts using `record-diagnosis` for bug fixes | `record-diagnosis` |
| `report.md` | `validation-review` | `validation-review` |
| `pr.md` | `prepare-pr` via `finalize-task` | `prepare-pr` |

## Workflow Notes

- Non-trivial tasks should pause after planning so the user can approve the plan before implementation continues.
- Simple tasks can go through `/quick-fix` when they stay within the quick-path guardrails.
- Bug work should prefer a failing regression test before the fix whenever the environment supports one.
- Validation is a first-class step. `report.md` should exist before finalization.
- If `report.md` is missing at finalization time, run `validation-review` before documentation and `pr.md` generation.

## Coding Suite Structure

```text
suites/
├── copilot-instructions.md
└── coding/
    ├── instructions/
    ├── prompts/
    └── skills/
        ├── analyze-codebase/
        ├── apply-migration/
        ├── artifact-management/
        ├── bug-triage/
        ├── capture-requirements/
        ├── prepare-pr/
        ├── project-context-onboarding/
        ├── record-diagnosis/
        ├── refresh-docs/
        ├── write-plan/
        └── validation-review/
```
