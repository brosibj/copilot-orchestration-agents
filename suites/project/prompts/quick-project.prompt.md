---
agent: 'agent'
description: "Route a tightly scoped project task to the project workflow without opening a larger loop than necessary."
tools: [vscode, agent, edit, todo]
---

Use this when the work is clearly bounded but still belongs to the project workflow rather than coding.

## Scope Guard
- single objective
- no multi-stage delivery plan needed
- no source-code implementation
- bounded coordination or writing effort

## Route
Invoke `@quick` with the scoped task details. If the scope expands, redirect to `@orchestrator`.
