---
name: Project Suite Rules
description: Shared suite constraints and conventions for project suite agents.
---

# Project Suite Rules

These rules apply only to the project suite agents in this package: `@orchestrator`, `@quick`, and the supporting project subagents. They do not automatically apply to built-in VS Code agents, unrelated custom agents, prompts, or skills unless those entry points explicitly invoke this workflow.

## Workflow Shape
- Keep the workflow loop-oriented.
- `@orchestrator` is the primary long-running loop controller.
- `@quick` is the compact path for tightly scoped project tasks.
- Planning is an activity inside the loop, not a locked phase.
- Preserve a reviewable current state through anchor artifacts.
- Prefer targeted iteration over rigid phase transitions.

## Shared References
- **Anchor templates:** `.github/agents/templates/summary.template.md`, `.github/agents/templates/worklog.template.md`

## Anchor Artifacts
- `summary.md` is the persistent source of current state.
- `worklog.md` is the rolling trace of what happened and why.
- All other artifacts are dynamic and should be created only when the task needs them.

## State Maintenance
- Update anchor artifacts after meaningful decisions, changed blockers, or changed next actions.
- Keep the current project state reviewable without replaying the full conversation.

## Parallel Dispatch
- The orchestrator may dispatch multiple project subagents in parallel only when they do not write the same file.
- Prefer one writer per artifact at a time.

## Confidence & Questions
- Use `vscode/askQuestions` when the objective, audience, constraints, or decision criteria are unclear.
- Batch questions when multiple ambiguities remain.
- Keep moving the project forward; do not stop at analysis if a reasonable next step is clear.

## Boundaries
- This workflow may handle bounded automation.
- If work becomes source-code implementation, compile/test verification, migrations, or deep debugging, route into the coding workflow instead of stretching this one.

## Standards
- Project workflow agents apply these rules in addition to the global `.github/copilot-instructions.md` baseline.
- Use active instruction files in `.github/instructions/*.instructions.md` when they apply, but do not assume coding-specific validation gates.

## Return Protocol
- Returns should be concise and routing-oriented.
- Include: status, summary, blockers, and recommended next action.

## Failure Protocol
- On failure, return what failed, why, what was tried, and the recommended next action.