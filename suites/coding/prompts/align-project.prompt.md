---
agent: 'agent'
description: "Align this repo's coding-suite customization to the current project state."
tools: [read, edit, search, vscode]
---

Apply [project context onboarding](../skills/project-context-onboarding/SKILL.md).

You are aligning this repository's GitHub Copilot coding-suite customization to the current adopting project.

## Behavior

- **First run:** gather project facts, then create/populate files.
- **Re-run:** read existing files first; update only what changed or is incomplete. Never overwrite content the user intends to keep.
- Work only within the coding suite and repo-local VS Code customization files. Do not modify the project suite.

## Step 1 — Gather Project Facts

Attempt to determine answers to all questions below from the repo's existing files. If any are missing, use `vscode/askQuestions` to collect the missing information in as few batches as possible. Iterate until all questions are answered:

1. **Workspace layout:** What are the main source roots, entrypoints, and package/workspace boundaries?
2. **Stack:** What are the primary language, runtime, framework, and package/workspace tools? (e.g., C# / ASP.NET Core / dotnet CLI, TypeScript / Next.js / pnpm)
3. **UI framework:** Which UI library or component framework, if any, is used? (e.g., Radzen Blazor, React, None)
4. **Test framework:** What test frameworks, runners, and test types are used? (e.g., xUnit + dotnet test, Jest + npm test, Playwright)
5. **Commands:** How do you build, run, lint/format, typecheck, and test the project?
6. **Architecture boundaries:** What repo-wide layering or dependency rules must always be preserved?
7. **Key coding standards:** Any project-specific rules to enforce? (e.g., "Use Result<T> for service returns", "No raw SQL")
8. **Data access:** ORM or query pattern? (e.g., EF Core, Dapper, None)
9. **Error handling convention:** How are errors surfaced? (e.g., exceptions, Result pattern, ProblemDetails)
10. **Domain-specific rules:** Which parts of the repo need their own focused instruction files? (e.g., API, data, migrations, scripts, e2e tests)
11. **Workspace scope:** Is this folder the repo root, or a subfolder/monorepo workspace that may need parent customization discovery?

## Step 2 — Choose The Right VS Code Context Surface

Map the gathered facts onto the VS Code customization surface that best fits them:

1. **`.github/copilot-instructions.md`**
	Use only for short, always-on repository context that should apply to every task. Keep this file concise and limited to project purpose, top-level invariants, shared terminology, and other guidance that truly must always load.
2. **`.github/instructions/project.instructions.md`**
	Use for core implementation guidance. Set `applyTo` to the primary implementation files or folders, not automatically `**` unless the repository genuinely has one uniform implementation surface.
3. **`.github/instructions/testing.instructions.md`**
	Use for test files and test folders only.
4. **`.github/instructions/styleguide.instructions.md`**
	Use for UI files only.
5. **Additional `.github/instructions/<domain>/<name>.instructions.md` files**
	Create focused domain files when a subset of the repo has meaningful rules that would otherwise clutter the project-wide files. Prefer one concern per file with a narrow `applyTo` glob and a precise `description`.
6. **Do not create `AGENTS.md` or `CLAUDE.md`** unless the user explicitly asks for cross-tool compatibility.

## Step 3 — Update Files

Using the project info and answers, update or create the following files from their template. For each, read the current file first if it exists.

### `.github/instructions/project.instructions.md` from `../skills/project-context-onboarding/templates/project.instructions.template.md`
- Set `description` and `applyTo` for the primary implementation files or folders.
- Populate with: stack, workspace layout, commands, architecture boundaries, coding standards, error handling, data access pattern, and migration/operational commands.
- Keep only core implementation guidance here. Move narrower rules to additional domain instruction files.

### `.github/instructions/testing.instructions.md` from `../skills/project-context-onboarding/templates/testing.instructions.template.md`
- Set `description` and `applyTo` to match actual test file locations and test types.
- Populate with: test frameworks, test runner commands, builders/fixtures, key patterns, and anti-patterns.
- If unit, integration, browser, or contract tests follow materially different rules, create additional focused testing instruction files instead of forcing them into one file.

### `.github/instructions/styleguide.instructions.md` from `../skills/project-context-onboarding/templates/styleguide.instructions.template.md`
- Create only if the repo has a UI layer.
- Set `description` and `applyTo` to match the actual UI files.
- Populate with: UI framework, component conventions, asset rules, and accessibility expectations.

### Additional domain instruction files from `../skills/project-context-onboarding/templates/domain.instructions.template.md`
- Create one file per domain or layer that has meaningful local rules, for example `data/ef-core.instructions.md`, `api/http.instructions.md`, `testing/playwright.instructions.md`, or `scripts/automation.instructions.md`.
- Use recursive folders under `.github/instructions/` when that makes updates clearer.
- Set a precise `description` and the narrowest useful `applyTo` glob.

### `.github/copilot-instructions.md`
- Keep this file for information that should always be loaded.
- Keep the global baseline intact.
- Update only with short, repository-wide context that truly applies to every task.
- Move file-type, framework, and domain-specific rules out into `.github/instructions/` files.

## Step 4 — Confirm
If any additional information is needed to fully complete the files, use `vscode/askQuestions` to clarify. Iterate until all files are complete and consistent with the project facts.

Once completed, list each file modified or created, what scope it owns, and any gaps that couldn't be answered from the provided information.

If the repo appears to be a subfolder workspace, mention `chat.useCustomizationsInParentRepositories`.
If the repo intentionally wants instruction files outside `.github/instructions/`, mention `chat.instructionsFilesLocations`; otherwise keep the default discovery path.
The coding suite should be usable through prompts and skills without requiring custom-agent setup. Only mention custom agents if the user explicitly asks to add one back.
