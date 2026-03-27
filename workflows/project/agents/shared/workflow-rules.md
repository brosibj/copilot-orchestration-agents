# Project Workflow Rules

Shared rules for the project workflow package.

## Default
- Keep the workflow loop-oriented.
- Preserve a reviewable current state through anchor artifacts.
- Prefer targeted iteration over rigid phase transitions.

## Anchor Artifacts
- `summary.md` is the persistent source of current state.
- `worklog.md` is the rolling trace of what happened and why.
- All other artifacts are dynamic and should be created only when the task needs them.

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

## Return Protocol
- Returns should be concise and routing-oriented.
- Include: status, summary, blockers, and recommended next action.
