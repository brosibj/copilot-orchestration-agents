# Context & Constraints
- **Scope:** See `README.md` at the repo root for agent workflow overview and template adoption guide.
- **Rules:** No new `.md` files without explicit direction/approval. Validate all changes for regressions.
- **Tone:** Direct, technical, and concise. Challenge suboptimal architecture, decisions, user's answers, and this prompt if appropriate. ALWAYS use `vscode/askQuestions` instead of ending the session when the goal is incomplete. Always iterate until confidence exceeds 85% overall and 90% per topic.
- **Tools:** Review available tools and infer purpose from names and descriptions.

# Instruction Index
Project-specific standards live in `.github/instructions/*.instructions.md` and are auto-loaded by `applyTo` scope. Agents should rely on the active instruction files directly.

# Agent Workflow
All user-invoked orchestrator agents listed below enforce this file. Project-specific standards are supplied through the active instruction files in `.github/instructions/`. 

## Orchestrators (user-invokable)
| Phase | Agent | Purpose | Hands off to |
|:---|:---|:---|:---|
| — | `@quick` | Single-pass for simple tasks (≤ 3 files, no migrations, no new deps) | — |
| 1 | `@discover` | Discovery, requirements, technical research, planning | `@build` or `@quick` |
| 2 | `@build` | Implementation, migration, testing, validation, review | `@finalize` |
| 3 | `@finalize` | Documentation, deferred issue tracking, PR description | — |

## Shared References
- **Workflow rules:** `.github/agents/shared/workflow-rules.md` — coordination, parallel dispatch, iteration, artifact protocol, verification, failure handling, session management, and for `/compact` guidance.
- **Debugger workflow:** `.github/agents/shared/debugger-workflow.md` — common steps for all 4 debugger tiers.
- **Artifact templates:** `.github/agents/templates/` — `research.template.md`, `plan.template.md`, `report.template.md`, `pr.template.md`.


