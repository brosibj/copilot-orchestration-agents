---
applyTo: '**/*Tests*/**,**/*.test.*,**/*.spec.*'
---

# Testing Standards

> **Template:** Replace the sections below with your project's actual values.
> This file is auto-loaded for test files and test-folder paths matching the `applyTo` glob.
> Adjust the glob to match your project's test layout (e.g. `**/*.Tests/**` or `tests/**`).

## Framework & Runner

- **Test framework:** <!-- e.g. xUnit, Jest, pytest -->
- **Assertion library:** <!-- e.g. FluentAssertions, Shouldly, chai -->
- **Mocking library:** <!-- e.g. NSubstitute, Moq, jest.fn() -->
- **Runner command:** <!-- e.g. `dotnet test`, `npx jest`, `pytest` -->

## Test Organisation

- **Project / folder layout:** <!-- e.g. `tests/<Feature>Tests/`, co-located `*.test.ts` -->
- **Naming convention:** <!-- e.g. `MethodName_Scenario_ExpectedResult` -->
- **Categories / traits:** <!-- e.g. `[Trait("Category", "Integration")]` for slow tests -->

## Builders & Fixtures

- **Test data builders:** <!-- e.g. `new UserBuilder().WithRole(Role.Admin).Build()` -->
- **Shared fixtures / setup:** <!-- e.g. `WebApplicationFactory<Program>` for integration tests -->
- **Database seeding:** <!-- e.g. Use `SeedData.Apply(context)` before each integration test -->

## Patterns

- Prefer **Arrange / Act / Assert** structure with a blank line separating each section.
- One logical assertion per test where practical; group related assertions with `AssertionScope` / `SoftAssertions`.
- Mock at the boundary (interfaces/ports), not deep in the call chain.

## Anti-Patterns

- Do **not** test implementation details — assert observable behaviour.
- Do **not** share mutable state across tests.
- Do **not** call external services or real databases in unit tests.
- <!-- Add project-specific anti-patterns here -->

## Additional Context

<!-- Add project-specific testing context here. -->
