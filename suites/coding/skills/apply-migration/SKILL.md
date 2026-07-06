---
name: apply-migration
description: 'Apply or refresh schema migrations using the commands defined by the active project instructions. Use when a plan or implementation requires database or schema changes.'
---

# Apply Migration

Apply [coding suite rules](../../instructions/suite-rules.instructions.md).

Use this skill when `plan.md` or the current implementation indicates that schema changes are required.

## Workflow
1. Read `plans/{task-slug}/plan.md` and inspect `Schema Changes`.
2. If migration direction or destructive impact is unclear, ask the user before running commands.
3. Execute the migration commands from the active project instructions.
4. Verify the generated migration: no spurious changes, correct `Up`/`Down`, and expected affected entities.
5. Summarize the migration name, affected entities, and verification result.

## Constraints
- Do not invent migration commands; use the active project instructions.
- Surface destructive or uncertain migration outcomes immediately.