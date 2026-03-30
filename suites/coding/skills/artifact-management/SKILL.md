---
name: artifact-management
description: "Conventions for writing fragment files, compiling research artifacts, and structuring agent return summaries. Use when producing or assembling task artifacts (research.md, report.md, plan.md, fragments, return summaries)."
user-invocable: false
---

# Artifact Management Conventions

## Artifact Locations
- Task artifacts: `plans/{task-slug}/` — `research.md`, `plan.md`, `report.md`, `pr.md`.
- Fragment files: `plans/{task-slug}/fragments/{scope-name}.md`.
- Templates: `.github/agents/templates/` — use as structural reference, not copy-paste.

## Fragment Writing
Write fragments when directed by an orchestrator for parallel research collection.

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

## Return Summaries
Subagents return structured summaries to the orchestrator — not file contents.

Required fields:
- **Status:** success / partial / blocked
- **Summary:** 2–3 sentences covering key findings or actions taken.
- **Blockers/Flags:** Any issues requiring orchestrator decision.
- **Routing Hints:** Next-step info the orchestrator needs (e.g., which step to execute next, dependency discovered).

Keep returns ≤10 lines. Do not paste artifact sections into the return.

## Artifact Quality Rules
- Missing artifact = **Artifact Missing** failure. Every agent that produces an artifact MUST create it.
- No raw code in artifacts. Small pseudocode is acceptable only when essential for clarity.
- Artifacts are append-only by default; do not truncate prior content when adding new sections.
- **Exception — `report.md`:** On validation retry, the assigned compiler overwrites `report.md` with updated results. Include notable prior findings (e.g., issues that were fixed) only when they add context for the reviewer. Do not accumulate full retry history.
