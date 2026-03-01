# Shared Debugger Workflow

All debugger tiers follow this workflow. Tier-specific instructions are in each agent file.

## Execution Steps

1. **Reproduce & Trace:** Read `{task-slug}/research.md` for bug description, expected vs actual behavior, and triage classification.
2. **Diagnose:** Identify the **root cause** (not just the symptom). Trace execution path from entry point to failure.
3. **Fix:** Apply the minimal, targeted fix that resolves the root cause.
4. **Build:** Run `dotnet build --no-incremental` via `execute` — 0 errors, 0 warnings required.
5. **Test:** Run `dotnet test` — regressions (previously passing tests now failing) must be resolved. See `.github/testing.md` for patterns.
6. **Document:** Write `{task-slug}/diagnosis.md` containing:
   - **Root Cause:** What went wrong and why (2-3 sentences).
   - **Fix:** Files modified with one-line description per file.
   - **Risk:** Areas that could be affected by this fix.

## Iteration & Escalation

- If no measurable progress within the iteration budget, return an **escalation signal** to the orchestrator with: what was tried, why it failed, and suggested next tier.
- Do NOT exceed the iteration budget defined in the tier-specific agent.

## Constraints

- Enforce `.github/copilot-instructions.md` and `.github/styleguide.md`.
- If the fix requires schema changes, flag this so the orchestrator can invoke `@migrator`.
- If `diagnosis.md` is not created, return failure status: **Artifact Missing**.
