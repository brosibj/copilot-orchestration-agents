# Agent Dispatch Rules

Shared rules governing how orchestrators dispatch sub-agents.

## Model Constraints

| Constraint | Rule |
|:---|:---|
| **Opus agents** | Single-instance only. Never fan-out. |
| **Non-Opus agents** | May run in parallel with strictly non-overlapping scopes/topics. |

## Opus Agents
`@requirements-builder`, `@planner`, `@reviewer`, `@debugger-forensic`

## Parallel Dispatch

- For parallel groups, dispatch all agent calls in the same turn.
- Parallel agents MUST have non-overlapping `[SCOPE]` tags.
- Never dispatch two agents that write to the same file.

## Artifact Protocol

- Every agent that produces an artifact MUST create it. Missing artifact = **Artifact Missing** failure.
- Artifacts are written to `plans/{task-slug}/`.
- Artifacts should reference prior artifacts (e.g., "see `research.md`") instead of restating their content.

## Standards Enforcement

All agents enforce:
- `.github/copilot-instructions.md` — technical standards, patterns, handling.
- `.github/styleguide.md` — UI/Radzen conventions.
- `.github/testing.md` — test patterns, builders, exclusions.

## User Interaction

- Use `vscode/askQuestions` for clarification. Iterate until confident.
- Summarize outcomes after every phase gate.
