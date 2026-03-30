---
name: Coding Suite Rules
description: Shared suite constraints and conventions for coding suite agents.
---

# Coding Suite Rules

These rules apply only to the coding suite agents in this package: `@quick`, `@discover`, `@build`, `@finalize`, and their supporting subagents. They do not automatically apply to built-in VS Code agents, unrelated custom agents, prompts, or skills unless those entry points explicitly invoke this workflow.

**Default:** When in doubt, delegate. Orchestrators coordinate; subagents execute.

## Workflow Shape

- `@quick` handles simple tasks in a single pass.
- `@discover` owns requirements, research, triage, and planning.
- `@build` owns execution, migrations, implementation routing, and validation.
- `@finalize` owns documentation refresh, deferred follow-up tracking, and PR-ready closure.

## Shared References

- **Debugger workflow:** `.github/agents/shared/debugger-workflow.md` — common steps for all debugger tiers.
- **Artifact templates:** `.github/agents/templates/` — `research.template.md`, `plan.template.md`, `report.template.md`, `pr.template.md`.

## Nested Dispatch

- Nested subagent dispatch is supported when users enable `chat.subagents.allowInvocationsFromSubagents` (`false` by default).
- **Soft cap:** use at most 3 nested subagent layers beneath the entry agent. Treat this as `entry agent -> primary worker -> specialist -> helper`. Stay below the platform max of 5 unless the user explicitly asks for deeper recursion.
- Top-level orchestrators (`@discover`, `@build`, `@finalize`) remain the only phase owners. Nested delegation exists to isolate focused worker subtasks, not to bypass phase ownership.
- Nested coordinators in this suite: `@requirements-builder`, `@researcher`, `@planner`, `@reviewer`, `@validator`, and `@quick` for inline research only.
- Leaf-by-default workers: implementers, `@migrator`, debugger tiers, `@documenter`, and `@deferred-tracker`. Avoid nested edit/edit fan-out unless a prompt explicitly restricts child work to read-only support.

## Orchestrator Constraints

Applies to P1, P2, P3 orchestrators. `@quick` is exempt (hybrid worker).

- **No file reads.** Orchestrators MUST NOT read file contents. All content-based decisions come from subagent return summaries.
- **Existence checks only.** Orchestrators may check whether an artifact file exists, but must not read its contents.
- **Pre-flight via subagent.** When an orchestrator needs routing info from an artifact (e.g., plan.md for step ordering), dispatch `@researcher` with a summarize scope to return compact routing data.
- **Prefer delegated artifact synthesis.** When a worker already owns compilation or templated artifact generation (for example `research.md`, `report.md`, or `pr.md`), prefer a subagent write over direct orchestrator editing.
- **Minimize context.** Keep orchestrator context lean — subagent returns should be concise and routing-focused.

## Parallel Dispatch

- Dispatch parallel agents in the same turn with non-overlapping `[SCOPE]` tags.
- Never dispatch two agents that write to the same file **concurrently**. Sequential writes are permitted.
- **Fragment pattern:** For parallel research, dispatch multiple `@researcher` instances each writing to `{task-slug}/fragments/{scope-name}.md`, then dispatch a compile `@researcher` to merge fragments into the target artifact.
- Nested helpers should return summaries by default. If child agents write files, assign each child a unique fragment or dedicated artifact path owned by the parent.
- Never let multiple nested agents write `research.md`, `plan.md`, `report.md`, or the same source file concurrently.

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
- This protocol applies at every nesting layer. Parent subagents merge child returns before responding upward.

## Artifacts

- Every agent that produces an artifact MUST create it. Missing artifact = **Artifact Missing** failure.
- Artifacts live in `plans/{task-slug}/`. Fragment files live in `plans/{task-slug}/fragments/`.
- Reference prior artifacts instead of restating their content.
- **No code in artifacts.** Artifacts MUST NOT include raw code unless small pseudocode is essential for clarity. Reference code by file path + line.

## Verification

After code changes, verify build per the active project instructions and tests per the active testing instructions. Applies to: implementers, debuggers, validator, quick.

## Standards

Coding workflow agents apply these rules in addition to the global `.github/copilot-instructions.md` baseline and the active instruction files in `.github/instructions/`.

Implementers and debuggers: consult relevant skills before writing code that touches frameworks with known lifecycle or disposal pitfalls.

When creating or modifying files in `.github/` (agent definitions, skills, shared docs), follow existing formatting: compressed reference style, no verbose prose.

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

## Session Management

- **Use `/compact` after major phase gates:** After discover → build or build → finalize handoffs, or when context feels overloaded, run `/compact` to trim history.
- **Custom focus text:** `/compact focus on {task-slug} plan decisions and implementation progress` — preserves routing decisions while trimming conversation bulk.
- **Artifact persistence:** Plans, artifacts, and fragments in `plans/{task-slug}/` survive compaction. Orchestrators must ensure critical routing data (step order, scope tags, schema decisions) is written to artifacts *before* compaction, not held only in conversation history.
- **Pre-compaction checklist:** Confirm task slug, current phase gate, next agent target, and any in-flight scope blocks are artifact-resident before issuing `/compact`.