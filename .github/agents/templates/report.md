# Report: {TASK_ID}

**Slug:** `{task-slug}` · **Date:** {date} · **Verdict:** Pass | Fail

---

## Summary
> 2-3 sentences: what was validated, overall result, blockers if any.

## Build & Test
| Check | Result | Notes |
|:---|:---|:---|
| `dotnet build --no-incremental` | ✅/❌ | {warnings/errors if any} |
| `dotnet test` | ✅/❌ {pass}/{total} | {failures if any} |

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
> Verify per `.github/testing.md`. Omit if no test changes.

| Check | Status |
|:---|:---|
| Test files exist for new services | ✅/❌ |
| Naming: `{Method}_{Scenario}_{Expected}` | ✅/❌ |
| `IDisposable` + `EnsureDeleted()` | ✅/❌ |
| FluentAssertions (no xUnit Assert) | ✅/❌ |
| Builders used for complex entities | ✅/❌ |

## Deferred Issues
> Non-blocking items to track for later. Captured by `@document` phase.

- {issue description — file reference — priority}

## Restart Recommendation (failures only)
> Omit if verdict is Pass.

| Failure Category | Restart Phase | Specifics |
|:---|:---|:---|
| Requirements Gap | @research | {details} |
| Design/Plan Flaw | @research → @planner | {details} |
| Implementation Bug | @implement → @implementer | {details} |
| Missing Tests | @implement → @implementer | {details} |
