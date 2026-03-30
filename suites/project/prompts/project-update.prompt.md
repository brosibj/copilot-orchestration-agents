---
agent: 'agent'
description: "Advance an existing project by updating state, priorities, blockers, or deliverables."
tools: [vscode, agent, edit, todo]
---

Use this prompt when a project already exists and needs another loop.

## Collect
Gather, in one batch when needed:
1. Existing project slug or artifact path
2. What changed since the last iteration
3. What needs to happen next
4. Any new blockers, stakeholders, or approvals

## Route
Invoke `@orchestrator` with the update and existing project context.
