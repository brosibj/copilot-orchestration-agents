---
name: bug-triage
description: 'Classify a bug into a practical investigation tier and record the likely scope, confidence, and escalation triggers. Use during planning for bug work before implementation starts.'
---

# Bug Triage

Apply [coding suite rules](../../instructions/suite-rules.instructions.md).

Use this skill when the task is a bug and `research.md` needs a triage section that explains likely scope and escalation cost.

## Workflow
1. Read the bug description, repro steps, expected behavior, actual behavior, and affected code paths.
2. Classify into exactly one tier:

| Tier | Scope |
|:---|:---|
| **Medic** | Compiler, syntax, or simple null-check issues |
| **Detective** | UI framework state, lifecycle, race, or interaction issues |
| **Specialist** | Backend, data, ORM, API routing, or query issues |
| **Forensic** | Architectural, dependency graph, concurrency, or memory issues |

3. Prefer the lower-cost tier when multiple tiers seem plausible, and state the conditions that should trigger escalation.
4. Record the result in the `Bug Triage` section of `research.md`.

## Constraints
- Triage is advisory; it does not change code.
- Keep the rationale short and evidence-based.