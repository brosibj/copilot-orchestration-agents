---
agent: 'agent'
description: "Collect bug details, then follow the coding-suite planning, execution, and wrap-up prompts with the current model."
tools: [read, edit, search, execute, vscode, web, 'search/usages', 'browser/openBrowserPage', 'browser/readPage', 'browser/screenshotPage', 'browser/clickElement', 'browser/navigatePage', 'microsoftdocs/mcp/*', 'radzen.mcp/*', todo, github/issue_read, github/list_issues, github/search_issues, github/search_pull_requests, github/issue_write, github/sub_issue_write, github/create_pull_request, github/update_pull_request]
---

Apply [coding suite rules](../instructions/suite-rules.instructions.md).
Use [discover and plan](./discover-plan.prompt.md), [execute plan](./execute-plan.prompt.md), and [finalize task](./finalize-task.prompt.md).

Collect the following bug details from the user, then continue with the referenced prompt workflow.

## Collect

Use `vscode/askQuestions` to collect the following in one batch:

1. **Title:** One-line summary of the bug.
2. **Steps to reproduce:** Numbered list of exact steps.
3. **Expected behavior:** What should happen.
4. **Actual behavior:** What actually happens (include error messages, stack traces, or screenshots if available).
5. **Environment:** Relevant context — browser, OS, version, feature flag, tenant, etc.
6. **Frequency:** Always / intermittent / only under specific conditions?

## Continue

Once collected, continue the workflow with this structured context:

```
Bug: {title}

**Repro:**
{steps}

**Expected:** {expected}
**Actual:** {actual}

**Environment:** {environment}
**Frequency:** {frequency}
```

Then:
1. Follow [discover and plan](./discover-plan.prompt.md) using the structured context above.
2. Preserve bug-triage and regression-test expectations throughout execution.
3. If the work is truly small enough for the quick path, you may switch to `/quick-fix` instead.
4. Otherwise pause after planning for approval, then follow [execute plan](./execute-plan.prompt.md) and [finalize task](./finalize-task.prompt.md).
