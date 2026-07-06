---
name: write-plan
description: 'Write or refresh plans/{task-slug}/plan.md from the approved research artifact. Use after requirements and technical analysis are complete and before implementation starts.'
argument-hint: '[plans/{task-slug}]'
---

# Write Plan

Apply [coding suite rules](../../instructions/suite-rules.instructions.md).
Apply [artifact management](../artifact-management/SKILL.md).

Use this skill inside the planning flow to produce the implementation plan artifact.

## Owned Templates
- [Plan template](./templates/plan.template.md)

## Workflow
1. Ensure `plans/{task-slug}/` exists and read `plans/{task-slug}/research.md` completely before planning.
2. If `research.md` is missing or incomplete, stop and route back to `capture-requirements`, `analyze-codebase`, or `/discover-plan` before writing the plan.
3. Search the codebase for exact file boundaries, reusable patterns, interface touchpoints, and migration implications.
4. If multiple independent scopes need file-boundary or test-impact confirmation, prefer read-only subagents in parallel and keep only their distilled recommendations in the parent context.
5. Write or refresh `plans/{task-slug}/plan.md` from the [plan template](./templates/plan.template.md).
6. Keep the plan actionable:
   - reference `research.md` instead of restating it
   - list every file expected to change, including tests
   - mark each step `[S]` or `[P]` with `[SCOPE: ...]`
   - call out schema changes, migration type, and known test limitations when relevant
7. If the design is still ambiguous, stop and resolve that ambiguity before finalizing the plan.

## Constraints
- No production source edits.
- `plan.md` should reflect the most likely execution order, not every theoretical option.
- The parent skill invocation owns `plan.md`; subagents may recommend scope and sequencing but should not compete to write the plan.