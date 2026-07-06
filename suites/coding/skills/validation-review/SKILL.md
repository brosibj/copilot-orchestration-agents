---
name: validation-review
description: 'Validate a coding task against its research, plan, and changed files, then write or refresh plans/{task-slug}/report.md. Use when you want a reusable post-change review and verification pass without switching to a custom agent.'
argument-hint: '[plans/{task-slug}]'
---

# Validation Review

Apply [coding suite rules](../../instructions/suite-rules.instructions.md).
Apply [artifact management](../artifact-management/SKILL.md).

Use this skill after source changes to produce a durable validation artifact.

## Owned Templates
- [Report template](./templates/report.template.md)

## Workflow
1. Read `plans/{task-slug}/research.md`. If it is missing, stop and route to `/discover-plan` before validating. Read `plan.md` when present, and `diagnosis.md` when present.
2. Inspect the changed files and compare them against the accepted scope and acceptance criteria.
3. Review the implementation across these lenses:
   - correctness and edge cases
   - security and unsafe data handling
   - performance and unnecessary blocking or heavy work
   - UI behavior and accessibility when visual output changed
   - scope discipline versus the agreed plan
4. For larger changes, split independent review lanes across subagents when it keeps the parent context cleaner. Good candidates are correctness/security review, browser verification, test-quality review, and baseline comparison. Keep `report.md` ownership with one designated writer.
5. Run the project build command and the relevant test commands from the active instruction files.
6. Compare the current build and test results against `Build Baseline` in `research.md`. Treat unchanged pre-existing warnings or failures as baseline debt unless the task regressed them, touched the failing area, or prevented the agreed acceptance criteria from passing.
7. When UI behavior changed and browser tools are available, perform proportional browser verification.
8. Evaluate test quality against the active testing instructions.
9. Write or refresh `plans/{task-slug}/report.md` from the [report template](./templates/report.template.md):
   - Build & Test
   - Requirements Coverage
   - Findings
   - Test Quality
   - Bug Resolution when `diagnosis.md` exists
   - Deferred Issues
   - Restart Recommendation when the verdict is `Fail`
10. Use `Pass` only when acceptance criteria are met, no unresolved Critical or Major finding blocks the task, and build/test results are no worse than the recorded baseline for the task's scope.
11. Overwrite stale `report.md` content on re-runs instead of appending retry history.
12. End with a concise verdict (`Pass` or `Fail`), the highest-severity findings, and the next recommended command.

## Constraints
- This skill owns `report.md`.
- Prefer reporting issues over widening into new implementation unless the user explicitly asked for immediate repair.