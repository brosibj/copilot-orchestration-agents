---
name: Coding Suite Rules
description: Shared suite constraints and conventions for coding suite prompts and skills.
---

# Coding Suite Rules

These rules apply to the coding suite prompts and skills in this package when those entry points explicitly reference this file. They do not automatically apply to unrelated prompts, skills, or custom agents.

**Default:** Prefer prompts for guided intake and skills for reusable workflow behavior. Keep the currently selected model unless the user explicitly asks for something else.

## Workflow Shape

- User-facing workflow prompts: `/align-project`, `/new-feature`, `/bug-report`, `/quick-fix`, `/discover-plan`, `/execute-plan`, `/finalize-task`.
- Skills are smaller reusable capabilities that prompts reference and that users may also invoke directly when they need only that slice.

## Shared References

- **Artifact conventions:** `.github/skills/artifact-management/SKILL.md`.
- **Template ownership:**
	- `capture-requirements` owns `research.template.md`
	- `write-plan` owns `plan.template.md`
	- `validation-review` owns `report.template.md`
	- `prepare-pr` owns `pr.template.md`
	- `record-diagnosis` owns `diagnosis.template.md`

## Prompt And Skill Composition

- Use prompts to collect structured inputs and then continue with the referenced skill workflow.
- Use skills for durable procedures, artifact generation, and repeatable execution rules.
- The agent directly invoked by the user remains the loop owner for the active prompt or skill. Keep that parent context lean and route deep detail work to subagents whenever the work can be scoped cleanly.
- If a workflow needs more than one skill, reference the supporting skills instead of duplicating their instructions.
- Do not require a custom agent unless tool gating or handoff behavior cannot be expressed cleanly with prompts and skills.
- When multiple procedures touch the same artifact, keep template ownership in exactly one creating skill and have other skills reference that template.
- Prefer smaller support skills for requirement capture, codebase analysis, plan writing, docs refresh, and PR prep; let broader user-facing skills compose them.

## Subagent Dispatch

- The user-invoked agent owns routing, clarification, scope control, artifact ownership decisions, and final synthesis.
- Delegate deep repo exploration, isolated implementation slices, independent validation lanes, doc-surface scans, and issue/PR lookups to focused subagents when those tasks can be bounded cleanly.
- Keep parent context lean: subagents should return concise summaries covering status, evidence, changed files, blockers, and the next recommendation. Do not paste raw logs or long code excerpts into the parent context unless they are required for a decision.
- Prefer support-only or return-only subagents by default. Only let a subagent write files when its ownership is explicit and it does not conflict with another active branch.
- Do not let subagents compete for loop ownership. The parent agent remains responsible for the overall workflow and user communication.

## Parallel Dispatch

- Run subagents in parallel only when they do not write the same file or artifact and the underlying commands are safe to execute concurrently.
- Prefer one writer per artifact at a time. `research.md`, `plan.md`, `report.md`, `pr.md`, and `diagnosis.md` each need a single owning branch during a given phase.
- When planning or analysis fans out, use fragments or structured subagent returns so the parent can compile the accepted results without carrying all raw detail in context.
- When implementation fans out, parallelize only `[P]` scopes or other clearly non-overlapping file sets. Serialize shared-file edits, migrations, and any validation step that depends on another branch's output.

## Research Pattern

- Use targeted search and nearby reads before broad exploration.
- Before reading or writing task artifacts, ensure `plans/{task-slug}/` exists.
- Direct skill invocation may accept `plans/{task-slug}` explicitly or derive the slug from the provided task title or context before continuing.
- For broad or multi-area research, prefer scoped read-only subagents and keep only their distilled findings in the parent context.
- When a task spans multiple distinct areas, you may use fragment files under `plans/{task-slug}/fragments/` and then compile them into the owning artifact.
- Never let two concurrent procedures write the same artifact.

## Confidence & Iteration

Applies to judgment-heavy prompts and skills such as planning, validation, and onboarding.

1. **Ask first.** Use `vscode/askQuestions` whenever requirements are ambiguous, design tradeoffs exist, or confidence on any topic is below 90%. Do not guess.
2. **Confidence gate.** Overall confidence across all topics MUST exceed 85% before proceeding to the next phase gate or producing artifacts. Evaluate confidence per topic — any individual topic below 90% requires targeted clarification before moving on.
3. **Batch questions.** When multiple topics need clarification, combine them into a single `vscode/askQuestions` call (up to 4 questions per call). Minimize round trips — never ask one question at a time when several are outstanding.
4. **Update artifacts.** After receiving new information (user answers, subagent findings), update the relevant artifact sections before proceeding.
5. **Iterate.** Re-check the local code path or artifact until confidence meets the gates above. Prefer targeted follow-ups over broad re-runs.
6. **Cap iterations.** Max 3 clarification rounds per phase gate to avoid stalling. If still uncertain after 3 rounds, present the best option with caveats and proceed.
7. **Never end prematurely.** Prompts and skills MUST use `vscode/askQuestions` to continue working when uncertainty blocks progress. Never stop with the goal half-complete when a clarification path exists.

## Artifacts

- Every workflow that produces an artifact MUST create it. Missing artifact = **Artifact Missing** failure.
- `artifact-management` owns task-workspace bootstrap: ensure `plans/{task-slug}/` exists first, create `fragments/` only when fan-out is actually used, and let the artifact-owning skill create any missing file from its own template.
- Artifacts live in `plans/{task-slug}/`. Fragment files live in `plans/{task-slug}/fragments/`.
- Reference prior artifacts instead of restating their content.
- **No code in artifacts.** Artifacts MUST NOT include raw code unless small pseudocode is essential for clarity. Reference code by file path + line.

## Verification

After code changes, verify build per the active project instructions and tests per the active testing instructions.
Compare build and test results against `Build Baseline` in `research.md`. Pre-existing warnings or failing tests count as baseline debt unless the task regressed them, changed the failing area, or blocked the agreed acceptance criteria.

## Standards

Coding workflow prompts and skills apply these rules in addition to the global `.github/copilot-instructions.md` baseline and the active instruction files in `.github/instructions/`.

Prefer skills for reusable procedures, resource bundles, and templates. Custom agents should be absent by default and only reintroduced when tool gating or handoff behavior is impossible to express cleanly otherwise.

Consult relevant installed skills before writing code that touches frameworks with known lifecycle or disposal pitfalls.

When creating or modifying files in `.github/` or suite customization files, follow existing formatting: compressed reference style, no verbose prose.

## User Interaction

- Prompts and skills may use `vscode/askQuestions` to clarify ambiguities.
- Summarize major phase outcomes before moving into the next destructive step.
- Finalization requires `report.md`. If it is missing, run `validation-review` before documentation or PR work.

## Progress Tracking

Use the `todo` tool when a workflow spans multiple artifacts, approval gates, or validation phases.

## Failure Protocol

On failure, return a structured block to the user:
- **What failed:** Step or action.
- **Why:** Root cause or error message.
- **What was tried:** Recovery attempts.
- **Suggested recovery:** Next steps or escalation path.

## Session Management

- **Use `/compact` after major phase gates:** After planning, after implementation, or when context feels overloaded, run `/compact` to trim history.
- **Custom focus text:** `/compact focus on {task-slug} plan decisions and implementation progress` — preserves routing decisions while trimming conversation bulk.
- **Artifact persistence:** Plans, artifacts, and fragments in `plans/{task-slug}/` survive compaction. Ensure critical routing data is written to artifacts *before* compaction, not held only in conversation history.
- **Pre-compaction checklist:** Confirm task slug, current phase gate, next recommended command, and any in-flight scope blocks are artifact-resident before issuing `/compact`.