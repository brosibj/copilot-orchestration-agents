---
name: refresh-docs
description: 'Update repository documentation proportionally to a completed coding change. Use during finalization when report.md shows user-facing or workflow-relevant changes.'
argument-hint: '[plans/{task-slug}]'
---

# Refresh Docs

Apply [coding suite rules](../../instructions/suite-rules.instructions.md).
Apply [artifact management](../artifact-management/SKILL.md).
Apply [update docs from history](../update-docs-from-history/SKILL.md).

Use this skill inside finalization to own documentation changes.

## Workflow
1. Read `plans/{task-slug}/research.md`, `plans/{task-slug}/report.md`, and `plans/{task-slug}/diagnosis.md` when present.
2. If `plans/{task-slug}/report.md` is missing, prefer `/validation-review {task-slug}` before the documentation pass so documentation scope matches the validated change.
3. Determine the documentation mode:
   - `Bug-Fix`: usually no docs unless user-facing behavior changed.
   - `Modification`: update existing docs only where behavior changed.
   - `New Feature`: update existing docs, and add a new `docs/` file only when a standalone user-facing explanation is justified.
4. Apply proportional updates:
   - trivial -> no docs
   - small -> inline doc edits only
   - medium -> update existing docs and cross-links
   - large -> broader doc refresh, optionally using [update docs from history](../update-docs-from-history/SKILL.md)

## Constraints
- Keep doc effort proportional.
- Avoid new markdown files unless the change clearly needs one.