# Project Suite

This document covers the project suite authored under `suites/project/`.

The project workflow shares the global baseline authored in `suites/copilot-instructions.md`. Project-specific orchestration behavior lives in `suites/project/agents/shared/workflow-rules.md`.

## Overview

The project workflow is intentionally open-ended. It is designed for long-running project work where research, planning, execution, coordination, and replanning are iterative activities rather than fixed handoff phases.

Primary entry points:

```text
@orchestrator   ← long-running project loop
@quick          ← compact project pass when scope is clearly bounded
```

## What It Is For

- research synthesis
- project planning and replanning
- requirements or product work
- documentation and process design
- backlog shaping and issue coordination
- bounded automation such as issue operations, API-driven project tasks, and artifact generation

## Core Model

The project workflow uses a single loop-oriented orchestrator.

Its cycle is:
1. clarify or repair the current objective
2. synthesize current state
3. dispatch the needed mix of analysis, writing, coordination, automation, and review
4. update project state artifacts
5. either loop again or close the current objective

Planning is treated as an activity inside the loop, not as a locked phase.

## Anchor Artifacts

The project workflow keeps two stable anchors:

- `summary.md` for objective, current state, decisions, blockers, and next actions
- `worklog.md` for the running iteration trace

Beyond those anchors, artifacts are dynamic and created only when the project needs them.

Examples:
- research notes
- option analyses
- stakeholder summaries
- process documents
- rollout checklists
- issue batches
- automation output summaries

## Getting Started

### 1. Run `/align-project`

Use the project suite setup prompt to capture or refresh the working norms for project-style orchestration in this repo.

### 2. Populate active project instructions

`/align-project` creates or updates `.github/instructions/project.instructions.md` from `.github/agents/templates/project.instructions.template.md`.

### 3. Start the loop

Use `/project-update` for iterative progress or invoke `@orchestrator` directly when you already have the project context.

## Agents

### `@orchestrator`

The primary loop controller. It decides what kind of work is needed next and keeps `summary.md` and `worklog.md` coherent.

### Intended Loop Workers

- `@intake` — clarify objective, constraints, stakeholders, and success criteria
- `@analyst` — perform scoped research, comparison, and evidence gathering
- `@synthesizer` — compress project state into decisions, blockers, and next actions
- `@writer` — produce or update project deliverables
- `@coordinator` — handle issue operations, sequencing, and follow-up tasks
- `@automator` — perform bounded automation such as issue operations or data transforms
- `@reviewer` — review deliverables and project state for coherence, completeness, and readiness

## Boundaries

The project workflow may handle bounded automation, but it should not absorb full code implementation behavior.

Route into the coding workflow when the work becomes:
- source-code implementation
- compile/test validation
- migrations
- debugger-style defect repair

## Prompts

- `align-project.prompt.md` — align project-suite setup and working norms to the current repo state
- `project-update.prompt.md` — advance an existing project state
- `quick-project.prompt.md` — compact path for clearly bounded project tasks that route to `@quick`

## Project Suite Structure

```text
suites/
├── copilot-instructions.md
└── project/
    ├── agents/
    │   ├── orchestrator.agent.md
    │   ├── quick.agent.md
    │   ├── intake.agent.md
    │   ├── analyst.agent.md
    │   ├── synthesizer.agent.md
    │   ├── writer.agent.md
    │   ├── coordinator.agent.md
    │   ├── automator.agent.md
    │   ├── reviewer.agent.md
    │   ├── shared/
    │   └── templates/
    ├── instructions/
    ├── prompts/
    └── skills/
```

## Suite-Local Templates

- `summary.template.md`
- `worklog.template.md`
- `project.instructions.template.md`

## Suite-Local Skill

- `project-artifact-management` — conventions for maintaining `summary.md`, `worklog.md`, and dynamic project artifacts
