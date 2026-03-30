# Project Suite

This document covers the project suite authored under `suites/project/`.

The project workflow shares the global baseline authored in `suites/copilot-instructions.md`. Project-specific orchestration behavior is authored in `suites/project/instructions/suite-rules.instructions.md`. Agents may link to that file as supplemental guidance, but the suite is designed to tolerate environments where referenced instructions are not loaded.

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
4. have the current owner update project state artifacts
5. either loop again or close the current objective

Planning is treated as an activity inside the loop, not as a locked phase.

## Nested Subagents

The project suite supports nested subagents when `chat.subagents.allowInvocationsFromSubagents` is enabled in VS Code.

- **Soft cap:** three nested layers beneath the entry agent. In practice: `entry agent -> worker -> specialist -> helper`. This stays below VS Code's hard maximum depth of 5.
- **Loop ownership stays intact:** `@orchestrator` remains the only loop owner.
- **Primary nested coordinators:** `@analyst`, `@writer`, `@coordinator`, `@reviewer`, and `@quick` for compact helper passes.
- **Anchor ownership rule:** one agent per branch owns `summary.md` and `worklog/`; nested helpers return summaries or write only dedicated artifacts for their parent to integrate.

## Anchor Artifacts

The project workflow keeps two stable anchors:

- `summary.md` for objective, current state, decisions, blockers, and next actions
- `worklog/` for the running iteration trace, with one small file per meaningful update such as `001-intake.md` or `002-research-findings.md`

Keep `summary.md` compact and move detailed history into `worklog/` entries or task-specific artifacts. Beyond those anchors, artifacts are dynamic and created only when the project needs them.

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

Use the project suite setup prompt to capture or refresh the working norms for project-style orchestration in this repo. The prompt now ends with an exact reminder block for enabling nested subagents.

### 2. Enable nested subagents

Nested worker orchestration is off by default in VS Code. Enable `chat.subagents.allowInvocationsFromSubagents` in either of these ways:

1. Settings UI: press `Ctrl+,`, search for `allow invocations from subagents`, then enable **Chat > Subagents: Allow Invocations From Subagents**.
2. Settings JSON: open Workspace Settings JSON for this repo only, or User Settings JSON for all repos, and add `"chat.subagents.allowInvocationsFromSubagents": true`.

Workspace settings are the safer default for a shared repo.

### 3. Populate active project instructions

`/align-project` creates or updates `.github/instructions/project.instructions.md` from `.github/agents/templates/project.instructions.template.md`.

### 4. Start the loop

Use `/project-update` for iterative progress or invoke `@orchestrator` directly when you already have the project context.

## Agents

### `@orchestrator`

The primary loop controller. It decides what kind of work is needed next, assigns anchor ownership to the right worker, and keeps `summary.md` and `worklog/` coherent through delegated owner passes rather than direct editing.

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

- `project-artifact-management` — conventions for maintaining `summary.md`, `worklog/`, and dynamic project artifacts
