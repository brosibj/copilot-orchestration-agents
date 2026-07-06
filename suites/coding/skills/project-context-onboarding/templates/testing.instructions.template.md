---
name: Testing Standards
description: Test framework, runner, layout, and quality expectations for this repository's test files.
applyTo: '**/*Tests*/**,**/*.test.*,**/*.spec.*'
---

# Testing Standards

> **Template:** Replace the sections below with your project's actual values.
> Scope this file to test files and test folders only. Create additional focused files when unit, integration, browser, or contract tests follow different rules.

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

## Related Context

- **Project instructions:** <!-- e.g. `.github/instructions/project.instructions.md` -->
- **Additional test-domain files:** <!-- e.g. `.github/instructions/testing/playwright.instructions.md` -->