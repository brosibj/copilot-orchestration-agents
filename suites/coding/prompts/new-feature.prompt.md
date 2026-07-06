---
agent: 'agent'
description: "Collect feature details, then follow the coding-suite planning, execution, and wrap-up prompts with the current model."
tools: [read, edit, search, execute, vscode, web, 'search/usages', 'browser/openBrowserPage', 'browser/readPage', 'browser/screenshotPage', 'browser/clickElement', 'browser/navigatePage', 'microsoftdocs/mcp/*', 'radzen.mcp/*', todo, github/issue_read, github/list_issues, github/search_issues, github/search_pull_requests, github/issue_write, github/sub_issue_write, github/create_pull_request, github/update_pull_request]
---

Apply [coding suite rules](../instructions/suite-rules.instructions.md).
Use [discover and plan](./discover-plan.prompt.md), [execute plan](./execute-plan.prompt.md), and [finalize task](./finalize-task.prompt.md).

Collect the following feature details from the user, then continue with the referenced prompt workflow.

## Collect

Use `vscode/askQuestions` to collect the following in one batch:

1. **Title:** One-line summary of the feature.
2. **Problem / motivation:** What user problem or gap does this solve?
3. **Proposed behavior:** How should it work? What does success look like?
4. **Affected areas:** Which parts of the codebase or product are involved?
5. **Constraints:** Any known technical, design, or scope constraints?
6. **Priority / deadline:** Is there urgency or a target milestone?

## Continue

Once collected, continue the workflow with this structured context:

```
Feature: {title}

**Motivation:** {problem}
**Proposed behavior:** {behavior}
**Affected areas:** {areas}
**Constraints:** {constraints}
**Priority:** {priority}
```

Then:
1. Follow [discover and plan](./discover-plan.prompt.md) using the structured context above.
2. If the resulting work is clearly small enough for the quick path, you may switch to `/quick-fix` instead.
3. For non-trivial work, pause after planning for approval.
4. After approval, follow [execute plan](./execute-plan.prompt.md), then [finalize task](./finalize-task.prompt.md).
