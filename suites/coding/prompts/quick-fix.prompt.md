---
agent: 'agent'
description: "Collect the minimum context for a small task, then complete the quick-path workflow with the current model."
tools: [read, edit, search, execute, vscode, web, 'search/usages', 'browser/openBrowserPage', 'browser/readPage', 'browser/screenshotPage', 'browser/clickElement', 'browser/navigatePage', 'microsoftdocs/mcp/*', 'radzen.mcp/*', todo, github/issue_read, github/list_issues, github/search_issues, github/search_pull_requests, github/issue_write, github/sub_issue_write, github/create_pull_request, github/update_pull_request]
---

Apply [coding suite rules](../instructions/suite-rules.instructions.md).
Use [artifact management](../skills/artifact-management/SKILL.md), [capture requirements](../skills/capture-requirements/SKILL.md), [analyze codebase](../skills/analyze-codebase/SKILL.md), [execute plan](./execute-plan.prompt.md), and [finalize task](./finalize-task.prompt.md).

Scope-check and continue with the quick-path prompt workflow.

## Scope Guard

Confirm ALL of the following before continuing. If any fail, redirect to `/new-feature`, `/bug-report`, or `/discover-plan` instead.

- Touches ≤ 3 files (excluding tests)
- No schema or migration changes
- No new dependencies
- Requirements are clear and unambiguous

## Collect

Use `vscode/askQuestions` to collect the following in one batch if not already provided:

1. **Task:** What needs to be done? (one or two sentences)
2. **Files / area:** Which file(s) or area of the codebase?
3. **Acceptance criteria:** How will you know it's done correctly?

## Continue

Once confirmed in scope, continue the workflow with this structured context:

```
{task}

Files: {files}
Acceptance: {acceptance_criteria}
```

Then:
1. If no `{task-slug}` or `research.md` exists, use [artifact management](../skills/artifact-management/SKILL.md) to derive or normalize `{task-slug}` and ensure `plans/{task-slug}/` exists, then create a lightweight `research.md` from the template owned by [capture requirements](../skills/capture-requirements/templates/research.template.md), using [capture requirements](../skills/capture-requirements/SKILL.md) and [analyze codebase](../skills/analyze-codebase/SKILL.md) only as much as needed for the small scope.
2. Follow [execute plan](./execute-plan.prompt.md) with the same context.
3. Finish with [finalize task](./finalize-task.prompt.md).
