---
name: analyze-codebase
description: 'Populate the technical-analysis portions of plans/{task-slug}/research.md, including affected components, current behavior, findings, risks, and build baseline. Use after requirements are captured and before plan writing.'
argument-hint: '[plans/{task-slug}]'
---

# Analyze Codebase

Apply [coding suite rules](../../instructions/suite-rules.instructions.md).
Apply [artifact management](../artifact-management/SKILL.md).
Apply [dependency audit](../dependency-audit/SKILL.md).

Use this skill inside the planning flow to own the research and artifact-analysis part of `research.md`.

## Workflow
1. Ensure `plans/{task-slug}/` exists, then read the current `research.md` so the analysis stays aligned to the accepted requirements.
2. If `research.md` is missing or does not yet contain accepted requirements, stop and route to `capture-requirements` or `/discover-plan` before doing deeper analysis.
3. Search the codebase for affected files, neighboring patterns, interfaces, and likely side effects.
4. When the work spans distinct areas, prefer read-only subagents per scope. Run them in parallel when scopes do not write the same files, and have them return concise summaries or write one fragment each.
5. When the work spans distinct areas, create `plans/{task-slug}/fragments/` on demand, then compile the fragment results back into `research.md`.
6. Write or refresh these sections in `plans/{task-slug}/research.md`:
   - `Technical Analysis`
   - `Findings`
   - `Build Baseline`
   - `Root Cause` for bugs only when justified by evidence
7. If a new package may be needed, follow [dependency audit](../dependency-audit/SKILL.md) before the plan depends on it.
8. Record risks and mitigations with enough precision for planning.

## Constraints
- No production source edits.
- Do not rewrite the requirements sections unless new evidence makes them clearly wrong.
- Keep `research.md` ownership local to the parent skill invocation or one explicitly designated writer.