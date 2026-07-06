# Report: {TASK_ID}

**Slug:** `{task-slug}` · **Date:** {date} · **Verdict:** Pass | Fail

---

## Summary
> 2-3 sentences: what was validated, overall result, blockers if any.

## Build & Test
> Compare current results to `Build Baseline` in `research.md`. Unchanged baseline debt belongs in `Notes` and does not automatically fail the task.

| Check | Baseline | Current | Status | Notes |
|:---|:---|:---|:---|:---|
| Build (per active project instructions) | {e.g. PASS, 2 warnings} | {e.g. PASS, 2 warnings} | PASS / FAIL | {new warnings/errors or baseline debt note} |
| Test (per active testing instructions) | {e.g. 1 known failing test} | PASS / FAIL {pass}/{total} | PASS / FAIL | {new failures or unchanged baseline debt} |

## Requirements Coverage
> Map each acceptance criterion from `research.md` to pass/fail.

| # | Criterion | Status | Evidence |
|:---|:---|:---|:---|
| AC-1 | {criterion} | PASS / FAIL | {brief evidence} |

## Findings

| # | Severity | File | Finding | Recommendation |
|:---|:---|:---|:---|:---|
| 1 | Critical / Major / Minor / Info | {path} | {what's wrong} | {fix} |

### Severity Legend
- **Critical:** Must fix before merge.
- **Major:** Should fix before merge when practical.
- **Minor:** Non-blocking but worthwhile.
- **Info:** Optional or informational.

## Test Quality
> Omit if no test files changed.

| Check | Status |
|:---|:---|
| {check derived from active testing instructions} | PASS / FAIL |

## Bug Resolution (bug-fix tasks only)
> Omit for feature tasks. Drawn from `diagnosis.md` when present.

- **Root Cause:** {2-3 sentences}
- **Fix Applied:** {files + one-line per file}
- **Regression Test:** {test name that proves the fix}

## Plan Deviations
> Omit if implementation matched plan.md.

| # | Planned | Actual | Justification | Impact |
|:---|:---|:---|:---|:---|
| 1 | {what plan.md said} | {what was actually done} | {why} | Minor / Major / Critical |

## Deferred Issues
- {issue description - file reference - priority}

## Restart Recommendation (failures only)
> Omit if verdict is Pass.

| Failure Category | Restart Phase | Specifics | What Was Tried | What to Avoid |
|:---|:---|:---|:---|:---|
| Requirements Gap | discover-plan | {details} | {approaches attempted} | {pitfalls for retry} |
| Plan Flaw | discover-plan | {details} | {approaches attempted} | {pitfalls for retry} |
| Implementation Bug | execute-plan | {details} | {approaches attempted} | {pitfalls for retry} |
| Missing Tests | execute-plan | {details} | {approaches attempted} | {pitfalls for retry} |