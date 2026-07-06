---
name: prepare-pr
description: 'Create approved deferred issues and write or refresh plans/{task-slug}/pr.md. Use during finalization after validation is complete and documentation updates are decided.'
argument-hint: '[plans/{task-slug}]'
---

# Prepare PR

Apply [coding suite rules](../../instructions/suite-rules.instructions.md).
Apply [artifact management](../artifact-management/SKILL.md).

Use this skill inside finalization to own PR artifact generation and approved deferred-item tracking.

## Owned Templates
- [PR template](./templates/pr.template.md)

## Workflow
1. Ensure `plans/{task-slug}/` exists, then read `research.md`, `plan.md` when present, and `diagnosis.md` when present.
2. Read `plans/{task-slug}/report.md`. If it is missing, stop and route to `/validation-review {task-slug}` before generating `pr.md`.
3. Review `Deferred Issues` in `report.md`, `Known Test Limitations` in `plan.md`, and any relevant TODOs.
4. Ask the user which deferred items, if any, should become GitHub issues before creating them.
5. Use support-only subagents for PR lookup, deferred-item triage, or changed-file summarization when that keeps the parent context smaller.
6. Search for an existing PR by branch or task slug and note its URL if found.
7. Write or refresh `plans/{task-slug}/pr.md` from the [PR template](./templates/pr.template.md):
   - summarize what changed
   - list modified files
   - include testing or migration sections only when they apply
   - include linked issues and deferred items
8. End by asking whether to create a new PR, update an existing PR, or stop after artifact generation.

## Constraints
- Do not reopen code changes here.
- This skill owns `pr.md`.