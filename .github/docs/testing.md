# Testing & Development Workflow

## 1. Stack & Infrastructure
- **Frameworks:** xUnit, FluentAssertions (no `Assert.*`), NSubstitute (interfaces only; no concrete mocks).
- **Projects:** `<ProjectName>.UnitTests`, `<ProjectName>.IntegrationTests`, `<ProjectName>.E2ETests`, `<ProjectName>.ComponentTests`.
- **Hard Gate:** `dotnet test` must return 0 failures. Regressions block merges. Justify new failures in `plan.md` under `## Known Test Limitations`.
- **Exclusions:** None at this time.

## 2. Test Strategy & Location
| Code Type | Project | Strategy |
| :--- | :--- | :--- |
| **Service/Business Logic** | `.UnitTests` | Mocks for all dependencies. |
| **Repository/Complex LINQ** | `.IntegrationTests` | SQLite (supports GroupBy/Cascade/Raw SQL). |
| **EF In-Memory Constraints**| `.IntegrationTests` | Use for `GroupBy` on navs, cascade deletes, or `FromSqlRaw`. |

## 3. Implementation Patterns
- **Naming:** `{MethodName}_{Scenario}_{ExpectedBehavior}`.
- **Data:** Use `TestDbContextFactory` (Unit: `CreateInMemoryContext`; Integration: `CreateTestDb`). Always implement `IDisposable` and call `EnsureDeleted()`.
- **Entities:** Use Fluent Builders (`EntityBuilder`, `ChildEntityBuilder`, `ConfigBuilder`). **Never** use inline `new T { ... }` if a builder exists.
- **Required Coverage:** Every service method must cover:
  1. **Happy Path:** Valid inputs → Success.
  2. **Edge Cases:** Nulls, empty strings, boundaries.
  3. **Failure Path:** Invalid inputs → `Result.Fail()`.

## 4. Development & Runtime Workflow
- **Pre-Commit Check:** Run `dotnet test` locally before every commit.
- **Iterative Testing:** Use `dotnet watch test` during active development to auto-run tests on file save.
- **Filtering:** Use `--filter "FullyQualifiedName~[ClassName]"` to isolate tests for the current feature to reduce noise.
- **Coverage Collection:** Run `dotnet test --collect:"XPlat Code Coverage"` periodically to verify the ≥ 80% line coverage target for new services.
- **Build Integrity:** Run `dotnet build --no-incremental` to ensure no warnings or errors were introduced by refactoring.

## 5. Anti-Patterns & Fixes
- **Static APIs:** Inject `IBackgroundJobClient` instead of using `BackgroundJob.Enqueue`.
- **Concrete Mocks:** Extract interface and mock the interface to avoid partial execution.
- **Context Leaks:** Prevent by implementing `IDisposable` in test classes.