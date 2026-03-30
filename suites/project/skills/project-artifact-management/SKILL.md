---
name: project-artifact-management
description: "Conventions for maintaining summary.md, worklog.md, and dynamic project artifacts in the open-ended project workflow."
user-invocable: false
---

# Project Artifact Management

## Anchor Artifacts
- `summary.md` keeps the current project state readable.
- `worklog.md` records what changed from loop to loop.

## Rules
1. Keep `summary.md` concise and current.
2. Append to `worklog.md`; do not rewrite history unless the log became inaccurate.
3. Create dynamic artifacts only when they serve a concrete project need.
4. Prefer updating an existing artifact over creating a new one.
5. When a dynamic artifact changes project direction, reflect that change in `summary.md`.
