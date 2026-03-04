# Shared Debugger Workflow

All debugger tiers follow this workflow. Tier-specific instructions are in each agent file.

## Execution Steps

1. **Reproduce & Trace:** Read `{task-slug}/research.md` for bug description, expected vs actual behavior, and triage classification.
2. **Diagnose:** Identify the **root cause** (not just the symptom). Trace execution path from entry point to failure.
3. **Regression Test:** Write a failing test that reproduces the bug. The fix (next step) must make it pass. See `.github/docs/testing.md` for patterns.
4. **Fix:** Apply the minimal, targeted fix that resolves the root cause. Verify the regression test now passes.
5. **Verify:** Run the verification steps from `.github/docs/project.md` § Build & Validation.
6. **Document:** Write `{task-slug}/diagnosis.md` containing:
   - **Root Cause:** What went wrong and why (2-3 sentences).
   - **Fix:** Files modified with one-line description per file.
   - **Risk:** Areas that could be affected by this fix.

## Iteration & Escalation

- If no measurable progress within the iteration budget, return an **escalation signal** to the orchestrator with: what was tried, why it failed, and suggested next tier.
- Do NOT exceed the iteration budget defined in the tier-specific agent.

## Constraints

- Enforce `.github/copilot-instructions.md` and all project docs listed in your agent's **Required References** section.
- If the fix requires schema changes, flag this so the orchestrator can invoke `@migrator`.
- If `diagnosis.md` is not created, return failure status: **Artifact Missing**.
