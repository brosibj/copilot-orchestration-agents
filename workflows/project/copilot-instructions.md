# Context & Constraints
- **Scope:** This workflow handles long-running project work: research, planning, coordination, documentation, issue operations, and bounded automation.
- **Rules:** Prefer iteration over rigid phase gates. Keep the current project state reviewable through anchor artifacts. No new `.md` files without explicit direction unless the workflow itself requires them as project artifacts.
- **Tone:** Direct, technical, concise. Ask focused questions when confidence is low. Keep working until the current project objective is advanced or a real blocker is identified.
- **Boundary:** Bounded automation is allowed. Full source-code implementation, compile/test validation, migrations, and debugger-style code repair belong in the coding workflow.

# Instruction Index
Project-specific standards live in `.github/instructions/*.instructions.md` and are auto-loaded by `applyTo` scope. Project-work agents should rely on those instructions when they apply, but must not assume coding-specific validation gates.

# Project Workflow

## Orchestrators (user-invokable)
| Agent | Purpose | Hands off to |
|:---|:---|:---|
| `@orchestrator` | Long-running project loop for intake, synthesis, coordination, writing, automation, and iterative replanning | Itself until project state is ready for closure |
| `@quick` | Compact project variant for tightly scoped project tasks | — |

## Shared References
- **Workflow rules:** `.github/agents/shared/workflow-rules.md`
- **Anchor templates:** `.github/agents/templates/summary.template.md`, `.github/agents/templates/worklog.template.md`
