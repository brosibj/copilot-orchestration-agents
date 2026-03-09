# Agent Workflow Rules

Shared rules for all orchestrators and sub-agents.

**Default:** When in doubt, delegate. Orchestrators coordinate; subagents execute.

## Platform Constraints

- **No nested subagent dispatch.** Subagents CANNOT invoke other subagents. Only orchestrators (and `@quick`) dispatch subagents. Design all workflows accordingly — if a subagent needs information from another agent's domain, the orchestrator must coordinate the handoff.

## Orchestrator Constraints

Applies to P1, P2, P3 orchestrators. `@quick` is exempt (hybrid worker).

- **No file reads.** Orchestrators MUST NOT read file contents. All content-based decisions come from subagent return summaries.
- **Existence checks only.** Orchestrators may check whether an artifact file exists, but must not read its contents.
- **Pre-flight via subagent.** When an orchestrator needs routing info from an artifact (e.g., plan.md for step ordering), dispatch `@researcher` with a summarize scope to return compact routing data.
- **Minimize context.** Keep orchestrator context lean — subagent returns should be concise and routing-focused.

## Parallel Dispatch

- Dispatch parallel agents in the same turn with non-overlapping `[SCOPE]` tags.
- Never dispatch two agents that write to the same file **concurrently**. Sequential writes are permitted.
- **Fragment pattern:** For parallel research, dispatch multiple `@researcher` instances each writing to `{task-slug}/fragments/{scope-name}.md`, then dispatch a compile `@researcher` to merge fragments into the target artifact.

## Confidence & Iteration

Applies to orchestrators and judgment-heavy subagents (researcher, requirements-builder, planner, reviewer, validator). Does NOT apply to lightweight workers (triage, deferred-tracker, documenter).

1. **Ask first.** Use `vscode/askQuestions` whenever requirements are ambiguous, design tradeoffs exist, or confidence on any topic is below 90%. Do not guess.
2. **Confidence gate.** Overall confidence across all topics MUST exceed 85% before proceeding to the next phase gate or producing artifacts. Evaluate confidence per topic — any individual topic below 90% requires targeted clarification before moving on.
3. **Batch questions.** When multiple topics need clarification, combine them into a single `vscode/askQuestions` call (up to 4 questions per call). Minimize round trips — never ask one question at a time when several are outstanding.
4. **Update artifacts.** After receiving new information (user answers, subagent findings), update the relevant artifact sections before proceeding.
5. **Iterate.** Re-dispatch subagents or re-ask the user until confidence meets the gates above. Prefer targeted follow-ups over broad re-runs.
6. **Cap iterations.** Max 3 clarification rounds per phase gate to avoid stalling. If still uncertain after 3 rounds, present the best option with caveats and proceed.
7. **Never end prematurely.** Agents MUST use `vscode/askQuestions` to continue working when uncertain or when needing user input. Never end a session without completing the agent's goal or receiving explicit user direction to stop.

## Return Protocol

Subagents return concise, structured summaries to the orchestrator — not raw file contents.

- **Keep returns brief.** Focus on status, key findings, and routing hints. Avoid restating artifact contents.
- **Structure:** Status (success/fail), Summary (2-3 sentences), Blockers/Flags (if any), Routing Hints (next-step info the orchestrator needs).

## Artifacts

- Every agent that produces an artifact MUST create it. Missing artifact = **Artifact Missing** failure.
- Artifacts live in `plans/{task-slug}/`. Fragment files live in `plans/{task-slug}/fragments/`.
- Reference prior artifacts instead of restating their content.
- **No code in artifacts.** Artifacts MUST NOT include raw code unless small pseudocode is essential for clarity. Reference code by file path + line.

## Verification

After code changes, verify build per `.github/docs/project.md` § Build & Validation and tests per `.github/docs/testing.md` § Build & Test Commands. Applies to: implementers, debuggers, validator, quick.

## Standards

All agents enforce `.github/copilot-instructions.md` (auto-loaded). Each agent additionally enforces the project docs listed in its **Required References** section. Consult the Docs Index in `copilot-instructions.md` for on-demand lookup.

Implementers and debuggers: scan `.github/docs/errata/` at init for applicable patterns/anti-patterns before writing code.

When creating or modifying files in `.github/` (agent definitions, errata, shared docs), follow existing formatting: compressed reference style, no verbose prose.

## User Interaction

- Any agent may use `vscode/askQuestions` to clarify ambiguities.
- Agents MUST use `vscode/askQuestions` rather than ending the session when the goal is incomplete.
- Orchestrators summarize outcomes after every phase gate.

## Progress Tracking

Orchestrators use the `todo` tool to track subagent dispatch, phase gates, and overall progress. Update status as each step completes.

## Failure Protocol

On failure, agents return a structured block to the orchestrator:
- **What failed:** Step or action.
- **Why:** Root cause or error message.
- **What was tried:** Recovery attempts.
- **Suggested recovery:** Next steps or escalation path.
