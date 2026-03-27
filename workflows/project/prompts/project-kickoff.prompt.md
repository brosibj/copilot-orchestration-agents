---
agent: 'agent'
description: "Start or resume a long-running project through the open-ended project orchestrator."
tools: [vscode, agent, edit, todo]
---

Collect the minimum context needed to start or resume a project, then route to `@orchestrator`.

## Collect
Use `vscode/askQuestions` to gather in one batch when missing:
1. Project objective
2. Current known state
3. Desired outputs or deliverables
4. Constraints or deadlines
5. Known blockers or dependencies

## Route
Invoke `@orchestrator` with the structured context and any existing `plans/{task-slug}` reference if one already exists.
