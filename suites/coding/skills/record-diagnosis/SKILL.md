---
name: record-diagnosis
description: 'Write or refresh plans/{task-slug}/diagnosis.md for a bug fix after the root cause and regression test are known.'
argument-hint: '[plans/{task-slug}]'
---

# Record Diagnosis

Apply [coding suite rules](../../instructions/suite-rules.instructions.md).
Apply [artifact management](../artifact-management/SKILL.md).

Use this skill during bug-fix implementation after the failing behavior, the fix, and the regression test are known.

## Owned Templates
- [Diagnosis template](./templates/diagnosis.template.md)

## Workflow
1. Ensure `plans/{task-slug}/` exists, then gather the confirmed root cause, modified files, regression test name, and remaining risk.
2. Read `plans/{task-slug}/research.md` when present so the diagnosis stays aligned to the agreed bug scope.
3. Write or refresh `plans/{task-slug}/diagnosis.md` from the [diagnosis template](./templates/diagnosis.template.md).
4. Keep the diagnosis concise and evidence-based.

## Constraints
- Do not speculate. Record only the diagnosed cause and the applied fix.
- This skill owns `diagnosis.md`.