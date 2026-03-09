---
agent: 'agent'
description: "Initialize or update this repo's instruction-driven workflow customization for a specific project."
tools: [read, edit, search, vscode]
---

You are setting up or updating this repository's GitHub Copilot workflow customization for a specific adopting project.

## Behavior

- **First run:** gather project facts, then create/populate files.
- **Re-run:** read existing files first; update only what changed or is incomplete. Never overwrite content the user intends to keep.

## Step 1 — Gather Project Facts

Attempt to determine answers to all questions below from the repo's existing files. If any are missing, use `vscode/askQuestions` to collect the missing information in as few batches as possible. Iterate until all questions are answered:

1. **Stack:** What is the primary language and framework? (e.g., C# / ASP.NET Core, TypeScript / Next.js)
2. **UI framework:** Which UI library or component framework, if any? (e.g., Radzen Blazor, React, None)
3. **Test framework:** What test framework and runner are used? (e.g., xUnit + dotnet test, Jest + npm test)
4. **Build command:** How do you build the project? (e.g., `dotnet build`, `npm run build`)
5. **Key coding standards:** Any project-specific rules to enforce? (e.g., "Use Result<T> for service returns", "No raw SQL")
6. **Data access:** ORM or query pattern? (e.g., EF Core, Dapper, None)
7. **Error handling convention:** How are errors surfaced? (e.g., exceptions, Result pattern, ProblemDetails)

## Step 2 — Update Files

Using the project info and answers, update or create the following files from their template. For each, read the current file first if it exists.

### `.github/instructions/project.instructions.md` from `.github/agents/templates/project.instructions.template.md`
- Set `applyTo: '**'`
- Populate with: stack, build command, coding standards, error handling, data access pattern.

### `.github/instructions/testing.instructions.md` from `.github/agents/templates/testing.instructions.template.md`
- Set `applyTo` to match test file locations (e.g., `'**/*Tests*/**,**/*.test.*'`).
- Populate with: test framework, test runner command, key patterns, anti-patterns.

### `.github/instructions/styleguide.instructions.md` from `.github/agents/templates/styleguide.instructions.template.md`
- Set `applyTo` to match UI file types (e.g., `'**/*.razor,**/*.css'`) or leave as `'**'` if no UI layer.
- Populate with: UI framework, component conventions, asset rules.

### `.github/copilot-instructions.md` — update the instruction inventory and project-standard references as needed
- Keep the Agent Workflow section unchanged unless explicitly asked.

## Step 3 — Confirm
If any additional information is needed to fully complete the files, use `vscode/askQuestions` to clarify. Iterate until all files are complete and consistent with the project facts.

Once completed, list each file modified or created,  and any gaps that couldn't be answered from the provided information.
