# Agent Dispatch Rules

Shared rules for all orchestrators and sub-agents.

**Default:** When in doubt, delegate. Orchestrators coordinate; subagents execute.

## Model Constraints

| Constraint | Rule |
|:---|:---|
| **Opus agents** | Single-instance only. Never fan-out. |
| **Non-Opus agents** | May run in parallel with non-overlapping `[SCOPE]` tags. |

**Opus Agents:** `@requirements-builder`, `@planner`, `@reviewer`, `@debugger-forensic`

## Parallel Dispatch

- Dispatch parallel agents in the same turn with non-overlapping `[SCOPE]` tags.
- Never dispatch two agents that write to the same file **concurrently**. Sequential writes are permitted.

## Confidence & Iteration

Applies to orchestrators and judgment-heavy subagents (researcher, requirements-builder, planner, reviewer, validator). Does NOT apply to lightweight workers (research-worker, triage, deferred-tracker, documenter).

1. **Ask first.** Use `vscode/askQuestions` whenever requirements are ambiguous, design tradeoffs exist, or confidence is below ~85%. Do not guess.
2. **Update artifacts.** After receiving new information (user answers, subagent findings), update the relevant artifact sections before proceeding.
3. **Iterate.** Re-dispatch subagents or re-ask the user until confidence reaches ~85-90%. Prefer targeted follow-ups over broad re-runs.
4. **Cap iterations.** Max 3 clarification rounds per phase gate to avoid stalling. If still uncertain after 3 rounds, present the best option with caveats and proceed.

## Artifacts

- Every agent that produces an artifact MUST create it. Missing artifact = **Artifact Missing** failure.
- Artifacts live in `plans/{task-slug}/`. Reference prior artifacts instead of restating their content.

## Standards

All agents enforce: `.github/copilot-instructions.md`, `.github/docs/styleguide.md`, `.github/docs/testing.md`, `.github/docs/errata/*.errata.md`.

Implementers and debuggers: scan `.github/docs/errata/` at init for applicable patterns/anti-patterns before writing code.

When creating or modifying files in `.github/` (agent definitions, errata, shared docs), follow existing formatting: compressed reference style, no verbose prose.

## User Interaction

- Any agent may use `vscode/askQuestions` to clarify ambiguities.
- Orchestrators summarize outcomes after every phase gate.

## Progress Tracking

Orchestrators use the `todo` tool to track subagent dispatch, phase gates, and overall progress. Update status as each step completes.

## Failure Protocol

On failure, agents return a structured block to the orchestrator:
- **What failed:** Step or action.
- **Why:** Root cause or error message.
- **What was tried:** Recovery attempts.
- **Suggested recovery:** Next steps or escalation path.
