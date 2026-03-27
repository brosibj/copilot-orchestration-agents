---
agent: 'agent'
description: "Structure a small-scope task and route to @quick for single-pass implementation."
tools: [vscode, read, agent, edit, search, execute, web, todo]
---

Scope-check and route to `@quick` for single-pass implementation.

## Scope Guard

Confirm ALL of the following before routing. If any fail, redirect to `@discover` instead.

- Touches ≤ 3 files (excluding tests)
- No schema or migration changes
- No new dependencies
- Requirements are clear and unambiguous

## Collect

Use `vscode/askQuestions` to collect the following in one batch if not already provided:

1. **Task:** What needs to be done? (one or two sentences)
2. **Files / area:** Which file(s) or area of the codebase?
3. **Acceptance criteria:** How will you know it's done correctly?

## Route

Once confirmed in scope, invoke `@quick` with this handoff:

```
{task}

Files: {files}
Acceptance: {acceptance_criteria}
```

`@quick` will implement, validate, and finalize in one pass.
