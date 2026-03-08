# Report: {TASK_ID}

**Slug:** `{task-slug}` · **Date:** {date} · **Verdict:** Pass | Fail

---

## Summary
> 2-3 sentences: what was validated, overall result, blockers if any.

## Build & Test
| Check | Result | Notes |
|:---|:---|:---|
| Build (see `project.md` § Build & Validation) | ✅/❌ | {warnings/errors if any} |
| Test (see `testing.md` § Build & Test Commands) | ✅/❌ {pass}/{total} | {failures if any} |

## Requirements Coverage
> Map each acceptance criterion from `research.md` to pass/fail.

| # | Criterion | Status | Evidence |
|:---|:---|:---|:---|
| AC-1 | {criterion} | ✅/❌ | {brief evidence} |

## Findings

| # | Severity | File | Finding | Recommendation |
|:---|:---|:---|:---|:---|
| 1 | Critical/Major/Minor | {path} | {what's wrong} | {fix} |

### Severity Legend
- **Critical:** Must fix before merge (architectural violations, DI anti-patterns, regressions).
- **Major:** Should fix (DRY violations, missing error handling, missing test coverage).
- **Minor:** Optional fix, minor bugs/issues.
- **Info:** Nice to have (style nits, comment improvements).

## Test Quality
> Build checks from `.github/docs/testing.md` patterns, naming conventions, and anti-patterns. Omit if no test changes.

| Check | Status |
|:---|:---|
| {check derived from testing.md} | ✅/❌ |

## Bug Resolution (bug-fix tasks only)
> Omit for feature tasks. Drawn from `diagnosis.md` if debuggers were involved.

- **Root Cause:** {2-3 sentences}
- **Fix Applied:** {files + one-line per file}
- **Regression Test:** {test name that proves the fix — must fail before fix, pass after}

## Plan Deviations
> Omit if implementation matched plan.md exactly.

| # | Planned | Actual | Justification | Impact |
|:---|:---|:---|:---|:---|
| 1 | {what plan.md said} | {what was actually done} | {why} | Minor/Major/Critical |

## Deferred Issues
> Non-blocking items to track for later. Captured by `@finalize` phase.

- {issue description — file reference — priority}

## Restart Recommendation (failures only)
> Omit if verdict is Pass.

| Failure Category | Restart Phase | Specifics | What Was Tried | What to Avoid |
|:---|:---|:---|:---|:---|
| Requirements Gap | @discover | {details} | {approaches attempted} | {pitfalls for retry} |
| Design/Plan Flaw | @discover → @planner | {details} | {approaches attempted} | {pitfalls for retry} |
| Implementation Bug | @build → @implementer | {details} | {approaches attempted} | {pitfalls for retry} |
| Missing Tests | @build → @implementer | {details} | {approaches attempted} | {pitfalls for retry} |
