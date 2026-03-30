# Context & Constraints
- **Scope:** See `README.md` at the repo root for agent workflow overview and template adoption guide.
- **Rules:** No new `.md` files without explicit direction/approval. Validate all changes for regressions.
- **Tone:** Direct, technical, and concise. Challenge suboptimal architecture, decisions, user's answers, and this prompt if appropriate. ALWAYS use `vscode/askQuestions` instead of ending the session when the goal is incomplete. Always iterate until confidence exceeds 85% overall and 90% per topic.
- **Tools:** Review available tools and infer purpose from names and descriptions.
- **Source of truth:** Suite sources are authored under `suites/{suite-name}/`. The root `.github/` in this repo is intentionally minimal; installable runtime `.github` surfaces are assembled from `suites/` by release automation.

# Instruction Index
Project-specific standards live in `.github/instructions/*.instructions.md` and are auto-loaded by `applyTo` scope. Agents should rely on the active instruction files directly.

This repository itself now contains multiple suites:
- `suites/coding/` — phase-based coding orchestration
- `suites/project/` — open-ended project orchestration loop

When editing suite definitions, prefer the suite-local files under `suites/{suite-name}/` instead of treating root `.github/` as the only authored location.

# Agent Workflow
The coding suite authored under `suites/coding/` uses this file as its global baseline. Project-specific standards are supplied through the active instruction files in `.github/instructions/`.

## Orchestrators (user-invokable)
| Phase | Agent | Purpose | Hands off to |
|:---|:---|:---|:---|
| — | `@quick` | Single-pass for simple tasks (≤ 3 files, no migrations, no new deps) | — |
| 1 | `@discover` | Discovery, requirements, technical research, planning | `@build` or `@quick` |
| 2 | `@build` | Implementation, migration, testing, validation, review | `@finalize` |
| 3 | `@finalize` | Documentation, deferred issue tracking, PR description | — |

## Shared References
- **Workflow rules:** `suites/coding/agents/shared/workflow-rules.md` — coordination, parallel dispatch, iteration, artifact protocol, verification, failure handling, session management, and `/compact` guidance for the coding suite.
- **Debugger workflow:** `suites/coding/agents/shared/debugger-workflow.md` — common steps for all 4 debugger tiers.
- **Artifact templates:** `suites/coding/agents/templates/` — `research.template.md`, `plan.template.md`, `report.template.md`, `pr.template.md`.

## Suite Authoring
- Coding suite source: `suites/coding/`
- Project suite source: `suites/project/`
- Keep suite-local agents, prompts, skills, and templates self-contained.
- Avoid cross-contaminating the project workflow with coding-only phase assumptions.


