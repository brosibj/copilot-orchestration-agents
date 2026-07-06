---
name: Project Standards
description: Core stack, architecture, build, and error-handling guidance for the primary implementation files in this repository.
applyTo: '**'
---

# Project Standards

> **Template:** Replace the sections below with your project's actual values.
> Scope this file to the primary implementation files or folders. Move layer-specific or domain-specific rules into focused `.instructions.md` files instead of expanding this file indefinitely.

## Stack

- **Language / Runtime:** <!-- e.g. C# 13 / .NET 9 -->
- **Framework:** <!-- e.g. ASP.NET Core 9, Blazor Server -->
- **Package / workspace tool:** <!-- e.g. dotnet CLI, npm workspaces, pnpm -->
- **Key libraries:** <!-- e.g. MediatR, FluentValidation, Serilog -->

## Workspace Layout

- **Primary source roots:** <!-- e.g. `src/App`, `src/Shared` -->
- **Entrypoints:** <!-- e.g. `Program.cs`, `src/main.tsx` -->
- **Important boundaries:** <!-- e.g. API layer must not reference EF entities directly -->

## Commands

```shell
# Build
# TODO: replace with your build command

# Run (development)
# TODO: replace with your dev-server command

# Lint / format
# TODO: replace with your lint/format command
```

## Architecture & Coding Standards

- **Error handling:** <!-- e.g. Use Result<T> for domain errors; throw only for programmer errors -->
- **Dependency injection / composition:** <!-- e.g. Register all services in Program.cs; prefer constructor injection -->
- **Data access:** <!-- e.g. Repositories only; no raw SQL outside migrations -->
- **Naming conventions:** <!-- e.g. PascalCase types, camelCase locals, _camelCase private fields -->
- **File organisation:** <!-- e.g. Feature-first folders under src/; one class per file -->
- **Dependency rules:** <!-- e.g. Controllers call services, never repositories directly -->

## Migrations & Operational Commands

- **Migration tool:** <!-- e.g. EF Core CLI (`dotnet ef`) -->
- **Create migration:** <!-- e.g. `dotnet ef migrations add <Name> -p src/Data` -->
- **Apply migration:** <!-- e.g. `dotnet ef database update` -->
- **Other required checks:** <!-- e.g. `npm run typecheck`, `dotnet format --verify-no-changes` -->

## Related Context

- **Testing instructions:** <!-- e.g. `.github/instructions/testing.instructions.md` -->
- **Styleguide instructions:** <!-- e.g. `.github/instructions/styleguide.instructions.md` -->
- **Domain instructions:** <!-- e.g. `.github/instructions/data/ef-core.instructions.md` -->