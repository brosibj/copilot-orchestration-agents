---
name: Project Suite Rules
description: Shared suite constraints and conventions for project suite agents.
---

# Project Suite Rules

These rules apply only to the project suite agents in this package: `@orchestrator`, `@quick`, and the supporting project subagents. They do not automatically apply to built-in VS Code agents, unrelated custom agents, prompts, or skills unless those entry points explicitly invoke this workflow.

## Workflow Shape
- Keep the workflow loop-oriented.
- `@orchestrator` is the primary long-running loop controller.
- `@quick` is the compact path for tightly scoped project tasks.
- Planning is an activity inside the loop, not a locked phase.
- Preserve a reviewable current state through anchor artifacts.
- Prefer targeted iteration over rigid phase transitions.

## Shared References
- **Anchor templates:** `.github/agents/templates/summary.template.md`, `.github/agents/templates/worklog.template.md`

## Anchor Artifacts
- `summary.md` is the persistent source of current state.
- `worklog.md` is the rolling trace of what happened and why.
- All other artifacts are dynamic and should be created only when the task needs them.

## State Maintenance
- Update anchor artifacts after meaningful decisions, changed blockers, or changed next actions.
- Keep the current project state reviewable without replaying the full conversation.

## Orchestrator Constraints

Applies to `@orchestrator`. `@quick` is exempt (hybrid worker).

- **No direct artifact reads.** `@orchestrator` should not read `summary.md`, `worklog.md`, or other project artifacts directly. Route synthesis and artifact inspection through worker returns.
- **No direct artifact writes.** `@orchestrator` chooses which worker owns anchor updates, but does not edit the anchors itself.
- **No direct external execution or data gathering.** Route research and web lookups to `@analyst`, coordination and GitHub operations to `@coordinator`, and execution tasks to `@automator`.
- **Existence checks and routing only.** The loop owner may generate or reuse the task slug, check whether anchors exist, ask questions, and choose the next worker mix.
- **Minimize context.** Keep orchestrator context lean by relying on concise worker summaries and explicit ownership transfers.

## Nested Dispatch
- Nested subagent dispatch is supported when users enable `chat.subagents.allowInvocationsFromSubagents` (`false` by default).
- **Soft cap:** use at most 3 nested subagent layers beneath the entry agent. Treat this as `entry agent -> worker -> specialist -> helper`, which stays below the platform max of 5.
- `@orchestrator` remains the only loop owner. Nested delegation is for focused helper work inside worker agents, not for spinning up competing loop controllers.
- Preferred nested coordinators: `@analyst`, `@writer`, `@coordinator`, `@reviewer`, and `@quick` for compact helper passes.
- Leaf-by-default workers: `@intake`, `@synthesizer`, and `@automator` unless a prompt explicitly says otherwise.

## Anchor Ownership
- Exactly one agent in a dispatch branch owns `summary.md` and `worklog.md` updates.
- Nested helpers default to support-only / return-only work or dedicated artifact writes. The parent coordinator integrates their results into the anchors.
- When a nested helper should avoid anchor writes, say so explicitly in the dispatch prompt.

## Parallel Dispatch
- The orchestrator may dispatch multiple project subagents in parallel only when they do not write the same file.
- Prefer one writer per artifact at a time.
- The same one-writer rule applies inside nested worker branches.

## Confidence & Questions
- Use `vscode/askQuestions` when the objective, audience, constraints, or decision criteria are unclear.
- Batch questions when multiple ambiguities remain.
- Keep moving the project forward; do not stop at analysis if a reasonable next step is clear.

## Boundaries
- This workflow may handle bounded automation.
- If work becomes source-code implementation, compile/test verification, migrations, or deep debugging, route into the coding workflow instead of stretching this one.

## Standards
- Project workflow agents apply these rules in addition to the global `.github/copilot-instructions.md` baseline.
- Use active instruction files in `.github/instructions/*.instructions.md` when they apply, but do not assume coding-specific validation gates.

## Return Protocol
- Returns should be concise and routing-oriented.
- Include: status, summary, blockers, and recommended next action.
- Nested helpers return to their parent agent first; the parent owns anchor updates unless the prompt explicitly transfers that responsibility.

## Failure Protocol
- On failure, return what failed, why, what was tried, and the recommended next action.
