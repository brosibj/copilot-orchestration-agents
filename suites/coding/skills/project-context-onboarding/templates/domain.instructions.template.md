---
name: Domain Standards
description: Focused rules for a specific layer, module, or domain in this repository.
applyTo: '**'
---

# Domain Standards

> **Template:** Rename this file for the target domain and replace the placeholders below.
> Use the narrowest useful `applyTo` glob and a description that clearly states when the file should apply.

## Domain

- **Name:** <!-- e.g. API, EF Core, Background Jobs, Playwright -->
- **Applies to:** <!-- e.g. `src/Api/**`, `src/Data/**`, `tests/E2E/**` -->
- **Purpose:** <!-- e.g. Capture rules that only apply to EF Core data access -->

## Required Patterns

- <!-- e.g. `DbContext` lifetime is scoped per request -->
- <!-- e.g. Use projection queries for read endpoints -->

## Avoid

- <!-- e.g. No lazy loading -->
- <!-- e.g. Do not call third-party APIs from controllers directly -->

## Commands & Checks

- **Primary command:** <!-- e.g. `dotnet ef migrations script` -->
- **Verification:** <!-- e.g. `npm run test:e2e` -->

## Related Context

- **Project instructions:** <!-- e.g. `.github/instructions/project.instructions.md` -->
- **Other linked files:** <!-- e.g. `.github/instructions/testing/playwright.instructions.md` -->