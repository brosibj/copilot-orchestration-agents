# Plan: {TASK_ID}

**Slug:** `{task-slug}` · **Date:** {date} · **Version:** 1.0
> Prerequisites: See `research.md` for requirements, analysis, and technical findings.

---

## Summary
> 2-3 sentence description of what will be built/fixed and the approach.

## Schema Changes
> Omit section if no migration needed.
- **Migration Required:** Yes / No
- **Type:** New / Rollback-and-Readd
- **Entities:** {e.g., `Order`, `OrderItem`}
- **Name:** {e.g., `AddDiscountToOrders`}
- **Data Loss Risk:** {e.g., "None — new nullable column."}

## Scope & Guardrails
- **Focus:** {namespace/folder}
- **Protected:** {files NOT to touch}
- **Interfaces:** {any interface changes — all consumers must update in same turn}
- **Side Effects:** {e.g., "re-render of Sidebar"}

## Test Plan
> See `.github/docs/testing.md` for patterns. Each new/modified service method needs tests.

| Action | File | Notes |
|:---|:---|:---|
| Create | `<ProjectName>.UnitTests/Services/{Service}Tests.cs` | Happy path, edge, failure |
| Update | `<ProjectName>.UnitTests/Services/{Existing}Tests.cs` | Add tests for: {methods} |
| Create | `<ProjectName>.UnitTests/Builders/{Entity}Builder.cs` | If new complex entity |

### Known Test Limitations
> Document any known limitations or gaps in test coverage, including justifications. Omit if none.


## Execution Steps
> `[P]` = parallel-ok, `[S]` = sequential. `[SCOPE]` = file boundaries for fan-out.

1. `[S] [SCOPE: Models/Entity.cs]` {description}
2. `[S] [SCOPE: Services/EntityService.cs]` {description}
3. `[P] [SCOPE: Components/Pages/PageA]` {description}
4. `[P] [SCOPE: Components/Pages/PageB]` {description}
5. `[P] [TEST] [SCOPE: <ProjectName>.UnitTests/Services/EntityServiceTests.cs]` Unit tests — happy path, edge cases, failure scenarios

## Definition of Done
- [ ] Build command passes (see `project.md` § Build & Validation) — 0 errors, 0 warnings
- [ ] Test command passes (see `testing.md` § Build & Test Commands) — 0 failures
- [ ] All acceptance criteria from `research.md` met
