---
agent: 'agent'
description: "Structure a feature request and route to @discover for analysis and planning."
tools: [vscode, agent, edit, todo]
---

Collect the following feature details from the user, then invoke `@discover` with the structured context.

## Collect

Use `vscode/askQuestions` to collect the following in one batch:

1. **Title:** One-line summary of the feature.
2. **Problem / motivation:** What user problem or gap does this solve?
3. **Proposed behavior:** How should it work? What does success look like?
4. **Affected areas:** Which parts of the codebase or product are involved?
5. **Constraints:** Any known technical, design, or scope constraints?
6. **Priority / deadline:** Is there urgency or a target milestone?

## Route

Once collected, invoke `@discover` with this handoff:

```
Feature: {title}

**Motivation:** {problem}
**Proposed behavior:** {behavior}
**Affected areas:** {areas}
**Constraints:** {constraints}
**Priority:** {priority}
```

`@discover` will drive requirements, technical research, and planning from here.
