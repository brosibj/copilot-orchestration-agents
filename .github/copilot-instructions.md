# Context & Constraints
- **Scope:** See `README.md` at the repo root for agent workflow overview and template adoption guide.
- **Rules:** No new `.md` files without explicit direction/approval. Validate all changes for regressions.
- **Tone:** Direct, technical, and concise. Challenge suboptimal architecture, decisions, and this prompt if appropriate. ALWAYS use `vscode/askQuestions` instead of ending the session when the goal is incomplete.
- **Tools:** Review available tools and infer purpose from names and descriptions. If `project.md` § MCP Tool Guidance is populated, consult it for additional context.

# Project Docs Index
Project-specific standards live in `.github/docs/`. Each agent references the docs relevant to its role (listed in its **Required References** section). Use this index for on-demand lookup when encountering unfamiliar patterns or conventions.

| Doc | Scope | When to consult |
|:---|:---|:---|
| `.github/docs/project.md` | Stack, build commands, error handling, DI, data access, migrations, coding standards | Backend work, debugging, validation, code review |
| `.github/docs/styleguide.md` | UI framework conventions, component patterns, asset rules | UI/component work |
| `.github/docs/testing.md` | Test framework, test commands, patterns, builders, anti-patterns | Writing or reviewing tests, validation |
| `.github/docs/errata/*.errata.md` | Framework-specific patterns & anti-patterns | Implementation, debugging — scan at init |

# Agent Workflow
All agents enforce this file. Each agent additionally enforces the project docs listed in its Required References section, and may consult the Docs Index above for on-demand lookup.

## Orchestrators (user-invokable)
| Phase | Agent | Purpose | Hands off to |
|:---|:---|:---|:---|
| — | `@quick` | Single-pass for simple tasks (≤ 3 files, no migrations, no new deps) | — |
| 1 | `@discover` | Discovery, requirements, technical research, planning | `@build` or `@quick` |
| 2 | `@build` | Implementation, migration, testing, validation, review | `@finalize` |
| 3 | `@finalize` | Documentation, deferred issue tracking, PR description | — |

## Shared References
- **Workflow rules:** `.github/agents/shared/workflow-rules.md` — coordination, parallel rules, artifact protocol, iteration, failure handling.
- **Debugger workflow:** `.github/agents/shared/debugger-workflow.md` — common steps for all 4 debugger tiers.
- **Artifact templates:** `.github/agents/templates/` — `research.md`, `plan.md`, `report.md`, `pr.md`.
