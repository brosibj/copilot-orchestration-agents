# Testing & Development Workflow

## 1. Stack & Infrastructure
- **Frameworks:** xUnit, FluentAssertions (no `Assert.*`), NSubstitute (interfaces only; no concrete mocks).
- **Test DB:** Microsoft.EntityFrameworkCore.Sqlite — integration test database provider.
- **Projects:** `<ProjectName>.UnitTests`, `<ProjectName>.IntegrationTests`, `<ProjectName>.E2ETests`, `<ProjectName>.ComponentTests`.
- **Exclusions:** None at this time.

## 2. Build & Test Commands
| Command | Purpose | Gate |
|:---|:---|:---|
| `dotnet test` | Run all tests | 0 failures |
| `dotnet test --filter "FullyQualifiedName~[ClassName]"` | Run targeted tests | — |
| `dotnet test --collect:"XPlat Code Coverage"` | Collect coverage | ≥ 80% line coverage for new services |
| `dotnet watch test` | Auto-run tests on save | — |

- **Gates are hard blocks.** Regressions block merges. New test failures block unless justified in `plan.md` → **Known Test Limitations**.

## 3. Test Strategy & Location
| Code Type | Project | Strategy |
| :--- | :--- | :--- |
| **Service/Business Logic** | `.UnitTests` | Mocks for all dependencies. |
| **Repository/Complex LINQ** | `.IntegrationTests` | SQLite (supports GroupBy/Cascade/Raw SQL). |
| **EF In-Memory Constraints**| `.IntegrationTests` | Use for `GroupBy` on navs, cascade deletes, or `FromSqlRaw`. |

## 4. Implementation Patterns
- **Naming:** `{MethodName}_{Scenario}_{ExpectedBehavior}`.
- **Data:** Use `TestDbContextFactory` (Unit: `CreateInMemoryContext`; Integration: `CreateTestDb`). Always implement `IDisposable` and call `EnsureDeleted()`.
- **Entities:** Use Fluent Builders (`EntityBuilder`, `ChildEntityBuilder`, `ConfigBuilder`). **Never** use inline `new T { ... }` if a builder exists.
- **Required Coverage:** Every service method must cover:
  1. **Happy Path:** Valid inputs → Success.
  2. **Edge Cases:** Nulls, empty strings, boundaries.
  3. **Failure Path:** Invalid inputs → `Result.Fail()`.

## 5. Development & Runtime Workflow
- **Pre-Commit Check:** Run build (`project.md` § Build & Validation) and test commands (§ 2 above) locally before every commit.
- **Build Integrity:** Run the build command from `project.md` to ensure no warnings or errors were introduced by refactoring.

## 6. Anti-Patterns & Fixes
- **Static APIs:** Inject `IBackgroundJobClient` instead of using `BackgroundJob.Enqueue`.
- **Concrete Mocks:** Extract interface and mock the interface to avoid partial execution.
- **Context Leaks:** Prevent by implementing `IDisposable` in test classes.