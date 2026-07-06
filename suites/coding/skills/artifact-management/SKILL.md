---
name: artifact-management
description: "Conventions for bootstrapping task workspaces, writing fragment files, compiling research artifacts, and structuring short workflow handoff summaries. Use when producing or assembling task artifacts (research.md, report.md, plan.md, fragments, and related summaries)."
user-invocable: false
---

# Artifact Management Conventions

## Task Workspace Bootstrap
- Resolve `{task-slug}` from an explicit `plans/{task-slug}` path first. If only a task title or short description is available, normalize it to kebab-case and reuse that slug consistently.
- Ensure `plans/{task-slug}/` exists before any artifact read or write.
- Create `plans/{task-slug}/fragments/` only when a workflow actually fans out into parallel research or analysis scopes.
- This skill owns location and bootstrap rules. The workflow that owns a template still creates the missing artifact file from that template.

## Artifact Locations
- Task artifacts: `plans/{task-slug}/` — `research.md`, `plan.md`, `report.md`, `pr.md`.
- Fragment files: `plans/{task-slug}/fragments/{scope-name}.md`.
- Templates live with the skill that creates the artifact:
	- `capture-requirements/templates/research.template.md`
	- `write-plan/templates/plan.template.md`
	- `validation-review/templates/report.template.md`
	- `prepare-pr/templates/pr.template.md`
	- `record-diagnosis/templates/diagnosis.template.md`

## Fragment Writing
Write fragments when a planning or analysis workflow benefits from parallel research collection.

- Prefer one scoped subagent per fragment when the work fans out cleanly. The parent or designated artifact owner compiles the fragment set afterward.
- **Format:** Bullet points only — what was found, what was not found, concerns/caveats.
- **Length:** 10–30 lines. No prose paragraphs.
- **Scope discipline:** One fragment per assigned scope. Do not bleed into adjacent scopes.
- **No code:** Reference code by file path and line number. No raw code blocks.

## Artifact Compilation
Compile fragments or structured worker returns into a target artifact when directed.

1. For fragment-based compilation, read all fragment files in `plans/{task-slug}/fragments/`.
2. For return-based compilation, synthesize the parent-provided summaries into the target artifact's sections.
3. Integrate, deduplicate, and organize the content.
4. Maintain the template's structure and section headings.
5. Do not restate fragment bullets or returned summaries verbatim; elevate them into coherent findings.
6. Reference prior artifacts instead of re-explaining their content.
7. Keep exactly one compiler/writer for the target artifact during compilation.

## Result Summaries
When one workflow stage hands off to another, keep the summary brief:
- **Status:** success / partial / blocked
- **Summary:** 2-3 sentences covering the important findings or actions taken
- **Blockers/Flags:** anything the next stage must know before proceeding
- **Routing Hints:** the next recommended command or phase

Keep summaries short. Do not paste full artifact sections into them.
Prefer summaries over raw logs so the parent workflow can stay context-light.

## Artifact Quality Rules
- Missing artifact = **Artifact Missing** failure. Every workflow that produces an artifact MUST create it.
- Missing task workspace is a bootstrap problem, not a reason to continue without artifacts. Create the workspace first, then continue.
- No raw code in artifacts. Small pseudocode is acceptable only when essential for clarity.
- Artifacts are append-only by default; do not truncate prior content when adding new sections.
- **Exception — `report.md`:** On validation retry, the validation workflow overwrites `report.md` with updated results. Include notable prior findings (e.g., issues that were fixed) only when they add context for the reviewer. Do not accumulate full retry history.
