---
name: capture-requirements
description: 'Write or refresh the Summary, Requirements, and Acceptance Criteria sections of plans/{task-slug}/research.md. Use during planning when task intent needs to be clarified before deeper codebase analysis.'
argument-hint: '[task title or plans/{task-slug}]'
---

# Capture Requirements

Apply [coding suite rules](../../instructions/suite-rules.instructions.md).
Apply [artifact management](../artifact-management/SKILL.md).

Use this skill inside the planning flow to own the intent-capture part of `research.md`.

## Owned Templates
- [Research template](./templates/research.template.md)

## Workflow
1. Resolve or derive `{task-slug}`, ensure `plans/{task-slug}/` exists, and create `research.md` from the owned template when it is missing.
2. Search the nearest relevant code paths and existing behavior so clarifying questions are grounded in the repo.
3. If more than one code surface needs grounding, prefer read-only subagents per surface and keep only their concise findings in the parent context.
4. Use `vscode/askQuestions` for missing or ambiguous requirements. Batch questions.
5. Write or refresh these sections in `plans/{task-slug}/research.md`:
   - `Summary`
   - `Requirements`
   - `Acceptance Criteria`
6. Keep the artifact concise and durable. Reference existing patterns instead of restating large amounts of code behavior.
7. Leave `Technical Analysis`, `Findings`, `Risks`, and `Build Baseline` for the supporting analysis flow.

## Constraints
- No production source edits.
- Reference code by file path and line, not pasted blocks.