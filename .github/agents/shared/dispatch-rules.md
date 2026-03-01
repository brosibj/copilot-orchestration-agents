# Agent Dispatch Rules

Shared rules governing how orchestrators dispatch sub-agents. Each agent's permitted actions and constraints are defined in its own agent definition file — this file governs only the universal rules that apply to all agents.

**Default:** When in doubt, delegate. Orchestrators synthesize and coordinate; subagents execute. Each agent is the authoritative source for what it may do directly vs. what it must delegate.

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
- `.github/addendums/styleguide.md` — UI/Radzen conventions.
- `.github/addendums/testing.md` — test patterns, builders, exclusions.

## User Interaction

- Any agent (orchestrator or subagent) may use `vscode/askQuestions` to clarify ambiguities before proceeding.
- Orchestrators summarize outcomes after every phase gate.
