# Testing Guide

**Framework:** xUnit · FluentAssertions · NSubstitute  
**Projects:** `<ProjectName>.UnitTests` (in-memory, fast) · `<ProjectName>.IntegrationTests` (SQLite, E2E)  
**Gate:** `dotnet build --no-incremental` must return 0 errors and 0 warnings for all code that was modified or affected by changes. `dotnet test` must pass (0 failures) before merge. Regressions always block. New failures require justification in `plan.md` under `## Known Test Limitations`.

> **Razor/UI testing** is deferred — not yet implemented. Do not create tests for components, layouts, or rendering behavior until a testing approach is formally adopted.

---

## Test Location Decision Table

| Code Type | Test Project | Test Type |
| :--- | :--- | :--- |
| **Service / business logic** | `<ProjectName>.UnitTests/Services/` | Unit — mocked dependencies |
| **Repository / complex LINQ** | `<ProjectName>.IntegrationTests/` | Integration — SQLite in-memory |
| **Razor page / component / layout** | Deferred | — |

---

## Naming Convention

`{MethodName}_{Scenario}_{ExpectedBehavior}`

**Examples:**
- `GetItemsAsync_WithNoFilters_ReturnsAllItems`
- `AddTagAsync_WithInvalidId_ReturnsFailure`
- `DeleteItemAsync_WithValidId_DeletesSuccessfully`

---

## Patterns

### DbContext
Use `TestDbContextFactory.CreateTestDb()` — returns a matched `(Context, Factory)` tuple sharing the same in-memory database. Always implement `IDisposable` and call `EnsureDeleted()` in cleanup.

```csharp
(_context, _contextFactory) = TestDbContextFactory.CreateTestDb();
```

For tests that don't need a factory (direct context access only):
```csharp
_context = TestDbContextFactory.CreateInMemoryContext();
```

### Mocking
NSubstitute interfaces only. Never mock concrete classes.

```csharp
_logger = Substitute.For<ILogger<MyService>>();
_jobClient = Substitute.For<IBackgroundJobClient>();
```

### Builders
Use fluent builders for complex entities — never construct entities inline with `new T { ... }` when a builder exists.

| Builder | Use For |
| :--- | :--- |
| `EntityBuilder` | Primary domain entities |
| `ChildEntityBuilder` | Nested/related entities |
| `ConfigBuilder` | Configuration/settings entities |

```csharp
var entity = new EntityBuilder()
    .WithProperty(value)
    .WithRelated(related)
    .Build();
```

### Assertions
FluentAssertions exclusively. Do not use xUnit `Assert.*`.

```csharp
result.Should().HaveCount(2);
result.Should().Contain(m => m.Id == 1);
result.Errors.First().Message.Should().Contain("not found");
```

### Coverage
Each service method needs:
1. Happy path (valid inputs → success)
2. Edge cases (empty, null, boundary values)
3. Failure path (invalid inputs → `Result.Fail()`)

---

## Explicit Exclusions — DO NOT Test

- Radzen component events, rendering, or `NotificationService` calls
- Hangfire `BackgroundJob` / `RecurringJob` static APIs
- EF Core query translation behavior
- ASP.NET Identity flows

---

## Anti-Patterns

| Anti-Pattern | Why | Fix |
| :--- | :--- | :--- |
| Mock concrete class | Partial mock executes real methods | Extract interface, mock that |
| Static API in service | `BackgroundJob.Enqueue()` = untestable | Inject `IBackgroundJobClient` |
| Missing `IDisposable` | Context leak across tests | Implement `IDisposable`, call `EnsureDeleted()` |
| EF In-Memory for GroupBy nav | Provider doesn't support it | Move to SQLite integration test |
| Constructing entities inline | Brittle, verbose setup | Use builders |

---

## Known Provider Limitations (EF In-Memory)

These patterns fail with the EF Core In-Memory provider and must be tested in `<ProjectName>.IntegrationTests` with SQLite:

- `GroupBy` on navigation properties
- Cascade deletes
- Raw SQL / `FromSqlRaw`

When a service method hits one of these, document it in `plan.md` under `## Known Test Limitations` and add an integration test step.

---

## Coverage (Coverlet)

**Package:** `coverlet.collector` — add to each test project:

```powershell
dotnet add <ProjectName>.UnitTests package coverlet.collector
dotnet add <ProjectName>.IntegrationTests package coverlet.collector
```

Do **not** specify a version. Do **not** modify `.csproj` manually.

### Collection

Coverage is collected via the `XPlat Code Coverage` data collector (built on Coverlet). Results are written to `TestResults/` as `coverage.cobertura.xml`.

```powershell
dotnet test --collect:"XPlat Code Coverage"
```

### Report Generation

Install the global `reportgenerator` tool (once per machine) and generate an HTML report:

```powershell
dotnet tool install -g dotnet-reportgenerator-globaltool
reportgenerator -reports:"**/TestResults/**/coverage.cobertura.xml" -targetdir:"coveragereport" -reporttypes:Html
```

### Thresholds

No hard threshold is enforced by CI at this time, but all **new service classes** must have:
- Happy path, edge case, and failure path covered (see Coverage under Patterns above).
- Line coverage ≥ 80% for service files is the target.

---

## Commands

```powershell
dotnet test                                                          # All tests
dotnet test <ProjectName>.UnitTests                                  # Unit only
dotnet test <ProjectName>.IntegrationTests                           # Integration only
dotnet test --filter "FullyQualifiedName~MyService"                  # Filtered
dotnet test --collect:"XPlat Code Coverage"                          # With coverage (Coverlet)
```
