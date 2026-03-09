---
agent: 'agent'
description: "Structure a bug report and route to @discover for analysis and planning."
tools: [vscode, agent, edit, todo]
---

Collect the following bug details from the user, then invoke `@discover` with the structured context.

## Collect

Use `vscode/askQuestions` to collect the following in one batch:

1. **Title:** One-line summary of the bug.
2. **Steps to reproduce:** Numbered list of exact steps.
3. **Expected behavior:** What should happen.
4. **Actual behavior:** What actually happens (include error messages, stack traces, or screenshots if available).
5. **Environment:** Relevant context — browser, OS, version, feature flag, tenant, etc.
6. **Frequency:** Always / intermittent / only under specific conditions?

## Route

Once collected, invoke `@discover` with this handoff:

```
Bug: {title}

**Repro:**
{steps}

**Expected:** {expected}
**Actual:** {actual}

**Environment:** {environment}
**Frequency:** {frequency}
```

`@discover` will drive triage, root-cause research, and planning from here.
