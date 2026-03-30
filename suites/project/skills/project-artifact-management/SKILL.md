---
name: project-artifact-management
description: "Conventions for maintaining summary.md, worklog/, and dynamic project artifacts in the open-ended project workflow."
user-invocable: false
---

# Project Artifact Management

## Anchor Artifacts
- `summary.md` keeps the current project state readable and compact.
- `worklog/` holds small trace files that record what changed from loop to loop.

## Rules
1. Keep `summary.md` concise and current; move older detail into `worklog/` or dedicated artifacts.
2. Add one small worklog entry file per meaningful update; do not rewrite older entries unless an entry became inaccurate.
3. Use zero-padded filenames with a short topic, for example `001-intake.md` or `002-research-findings.md`.
4. If only a legacy `worklog.md` exists, read it as history and resume new entries under `worklog/`.
5. Create dynamic artifacts only when they serve a concrete project need.
6. Prefer updating an existing artifact over creating a new one.
7. When a dynamic artifact changes project direction, reflect that change in `summary.md`.
