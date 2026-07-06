---
agent: 'agent'
description: "Create or refresh research.md and plan.md for a feature, bug, or non-trivial change."
tools: [read, edit, search, execute, vscode, web, 'search/usages', todo, 'microsoftdocs/mcp/*', 'radzen.mcp/*', github/issue_read, github/list_issues, github/search_issues]
---

Apply [coding suite rules](../instructions/suite-rules.instructions.md).
Use [artifact management](../skills/artifact-management/SKILL.md), [capture requirements](../skills/capture-requirements/SKILL.md), [analyze codebase](../skills/analyze-codebase/SKILL.md), [write plan](../skills/write-plan/SKILL.md), [bug triage](../skills/bug-triage/SKILL.md), and [dependency audit](../skills/dependency-audit/SKILL.md).

Use this prompt when the task needs durable planning artifacts before code edits begin.

## Workflow

1. Use [artifact management](../skills/artifact-management/SKILL.md) to derive or normalize `{task-slug}`, ensure `plans/{task-slug}/` exists, and create `fragments/` only when planning fan-out is actually needed.
2. Determine task type: `Feature`, `Enhancement`, `Refactor`, or `Bug-Fix`.
3. Read existing `research.md` or `plan.md` first when they already exist. Update incrementally instead of overwriting valid user content.
4. Create or refresh `plans/{task-slug}/research.md` from the template owned by [capture requirements](../skills/capture-requirements/templates/research.template.md).
5. Keep the entry agent focused on routing, clarification, and artifact synthesis. Delegate broad requirement-grounding or technical investigation to scoped subagents when the work spans distinct areas.
6. Use [capture requirements](../skills/capture-requirements/SKILL.md) to own `Summary`, `Requirements`, and `Acceptance Criteria`.
7. Use [analyze codebase](../skills/analyze-codebase/SKILL.md) to populate `Technical Analysis`, `Findings`, `Build Baseline`, and bug-only root-cause details when justified.
8. If a new package may be needed, follow [dependency audit](../skills/dependency-audit/SKILL.md) before the plan depends on it. New packages require explicit user approval.
9. Classify complexity:
   - `Simple`: all true -> touches at most 3 non-test files, no schema or migration changes, no new dependency, requirements are unambiguous.
   - `Standard`: anything else.
10. For bug tasks, use [bug triage](../skills/bug-triage/SKILL.md) and record the result in `research.md`.
11. For `Standard` work, use [write plan](../skills/write-plan/SKILL.md) to create or refresh `plans/{task-slug}/plan.md` from the template it owns.
12. For `Simple` work, either create a concise `plan.md` when the user explicitly wants one or recommend `/quick-fix {task-slug}`.
13. End with `{task-slug}`, task type, complexity, whether workspace bootstrap was needed, whether subagent fan-out was used, artifacts created, major risks, and the recommended next prompt.

## Constraints

- Do not modify production source files in this prompt.
- Pause after planning for user approval when the work is non-trivial.