---
agent: 'agent'
description: "Execute a planned coding change, including code edits, tests, migrations, and report refresh."
tools: [read, edit, search, execute, vscode, web, 'search/usages', 'browser/openBrowserPage', 'browser/readPage', 'browser/screenshotPage', 'browser/clickElement', 'browser/navigatePage', todo, 'microsoftdocs/mcp/*', 'radzen.mcp/*', github/issue_read, github/list_issues, github/search_issues]
---

Apply [coding suite rules](../instructions/suite-rules.instructions.md).
Use [apply migration](../skills/apply-migration/SKILL.md), [record diagnosis](../skills/record-diagnosis/SKILL.md), [validation review](../skills/validation-review/SKILL.md), and [dependency audit](../skills/dependency-audit/SKILL.md).

Use this prompt when `research.md` already exists and the task is ready for implementation.

## Workflow

1. Read `plans/{task-slug}/research.md`. If it is missing, stop and redirect to `/discover-plan` instead of guessing. Read `plan.md` when present; quick-fix work may intentionally omit it.
2. If the task is still ambiguous, stop and redirect to `/discover-plan` instead of guessing.
3. If the task is a bug fix, prefer a regression-test-first loop when the environment supports one:
   - reproduce the bug,
   - add a failing test,
   - fix the root cause,
   - make the regression test pass,
   - then use [record diagnosis](../skills/record-diagnosis/SKILL.md) to write `plans/{task-slug}/diagnosis.md` from its owned template.
4. If schema changes are required, use [apply migration](../skills/apply-migration/SKILL.md).
5. Before adding a new package, follow [dependency audit](../skills/dependency-audit/SKILL.md) and obtain explicit user approval.
6. Keep the entry agent focused on orchestration, scope control, and integration. When the plan has independent `[P]` scopes or other clearly non-overlapping file sets, delegate those slices to parallel subagents instead of carrying all implementation detail in the parent context.
7. Implement the code changes directly in the workspace, following the active project, testing, and styleguide instructions.
8. Update or add tests with the same scope as the code change.
9. Run the narrowest useful validation immediately after the first substantive edit and continue iterating locally until the touched slice is stable.
10. Use [validation review](../skills/validation-review/SKILL.md) to refresh `plans/{task-slug}/report.md` before concluding the implementation phase.
11. End with the files changed, build/test status, report status, whether subagent fan-out was used, and the recommended next prompt: `/finalize-task {task-slug}`.

## Constraints

- Fix the root cause rather than layering cosmetic patches.
- Do not create `pr.md`; finalization owns that artifact.