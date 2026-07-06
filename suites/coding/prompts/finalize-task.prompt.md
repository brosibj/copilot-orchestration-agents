---
agent: 'agent'
description: "Complete docs, deferred-item handling, and pr.md generation for a finished coding task."
tools: [read, edit, search, execute, vscode, web, todo, github/issue_read, github/issue_write, github/list_issues, github/search_issues, github/search_pull_requests, github/sub_issue_write, github/create_pull_request, github/update_pull_request]
---

Apply [coding suite rules](../instructions/suite-rules.instructions.md).
Use [validation review](../skills/validation-review/SKILL.md), [refresh docs](../skills/refresh-docs/SKILL.md), and [prepare pr](../skills/prepare-pr/SKILL.md).

Use this prompt after implementation when the task is ready for closure. Ensure `report.md` exists before concluding finalization.

## Workflow

1. Read `plans/{task-slug}/research.md`, `plan.md` when present, and `diagnosis.md` when present.
2. If `plans/{task-slug}/report.md` is missing, run [validation review](../skills/validation-review/SKILL.md) to create it before documentation or PR work. If validation cannot proceed because implementation artifacts are missing, redirect to `/execute-plan`.
3. Read `plans/{task-slug}/report.md`.
4. Keep the entry agent on closure routing and synthesis. Use subagents for doc-surface scans or PR/deferred-item reconnaissance when those checks are independent, but keep conflicting writes serialized.
5. Run the documentation pass from [refresh docs](../skills/refresh-docs/SKILL.md).
6. Run the PR and deferred-item pass from [prepare pr](../skills/prepare-pr/SKILL.md).
7. End by asking whether to create a new PR, update an existing PR, or stop after artifact generation.

## Constraints

- Keep documentation effort proportional to the size and visibility of the change.
- Do not reopen code changes here unless the user explicitly redirects the workflow.