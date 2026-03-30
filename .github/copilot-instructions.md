# Context & Constraints
- **Scope:** See `README.md` at the repo root for agent workflow overview and template adoption guide.
- **Rules:** No new `.md` files without explicit direction/approval. Validate all changes for regressions.
- **Tone:** Direct, technical, and concise. Challenge suboptimal architecture, decisions, user's answers, and this prompt if appropriate. ALWAYS use `vscode/askQuestions` instead of ending the session when the goal is incomplete. Always iterate until confidence exceeds 85% overall and 90% per topic.
- **Tools:** Review available tools and infer purpose from names and descriptions.
- **Source of truth:** Use `suites/copilot-instructions.md` as the baseline for this file. Suite sources are authored under `suites/{suite-name}/`, optional skills are authored under `skills/`, and release assets are assembled from those authored sources.
- **Reuse first:** Consider and leverage all existing tools, skills, instructions, suites, and scripts before creating something new.
- **Formalize reusable logic:** When temporary release, packaging, or setup logic becomes reusable, move it into a maintained script or authored source file instead of duplicating it in YAML or chat output.

# Instruction Index
Project-specific standards live in `.github/instructions/*.instructions.md` and are auto-loaded by `applyTo` scope. Agents should rely on the active instruction files directly.

This repository itself now contains multiple suites:
- `suites/coding/` — phase-based coding orchestration
- `suites/project/` — open-ended project orchestration loop

Optional cross-project or domain-specific skills live under `skills/` and can be released separately as a `.github/skills` bundle.

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
- Optional skills source: `skills/`
- Keep suite-local agents, prompts, skills, and templates self-contained.
- Avoid cross-contaminating the project workflow with coding-only phase assumptions.


