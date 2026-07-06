---
name: project-context-onboarding
description: 'Create or refresh repo-local Copilot context files for the coding suite. Use when onboarding a repository, when stack/build/testing conventions changed, or when /align-project needs to resync project context.'
user-invocable: false
---

# Project Context Onboarding

Use this skill to onboard or refresh repository-specific Copilot context for the coding suite.

## VS Code Context Layering
- `.github/copilot-instructions.md` is for short, always-on repository context that should apply to every chat request. Keep it high-signal and stable.
- `.github/instructions/*.instructions.md` files are for file-scoped or domain-scoped guidance. Prefer multiple focused files with clear `description` values and narrow `applyTo` globs over one large catch-all file.
- `.github/instructions/` is searched recursively, so group domain files into subfolders when that makes updates clearer.
- `AGENTS.md` and `CLAUDE.md` are optional cross-tool compatibility layers. Do not create them for this suite unless the user explicitly asks for them.
- Prompt files are reusable entry points, not persistent standards storage.

## Owned Resources
- [Project instructions template](./templates/project.instructions.template.md)
- [Testing instructions template](./templates/testing.instructions.template.md)
- [Styleguide instructions template](./templates/styleguide.instructions.template.md)
- [Domain instructions template](./templates/domain.instructions.template.md)

## Workflow
1. Infer as much as possible from the repository before asking the user anything.
2. Ask for missing information in as few `vscode/askQuestions` batches as possible.
3. Sort findings into the right VS Code surface:
   - Always-on repo context -> `.github/copilot-instructions.md`
   - Core implementation guidance -> `.github/instructions/project.instructions.md`
   - Test guidance -> `.github/instructions/testing.instructions.md`
   - UI guidance -> `.github/instructions/styleguide.instructions.md`
   - Narrow domain or layer rules -> additional `.github/instructions/<domain>/<name>.instructions.md` files
4. Keep each file concise, editable, and scoped to one responsibility.
5. On re-runs, read existing files first and preserve valid user-authored content.

## Domain File Guidelines
- Create a separate domain file only when a subset of the codebase has material rules that would otherwise overload the core project instructions.
- Good candidates: `api/`, `data/`, `frontend/`, `backend/`, `ops/`, `migrations/`, `scripts/`.
- Prefer one domain concern per file. Use the narrowest `applyTo` glob that still covers the relevant files.
- Use the file `description` to improve semantic matching for non-file-centric tasks.

## Completion Notes
- Summarize which files were created or updated and what scope each file owns.
- If the repo is opened from a subfolder of a larger repository, call out the `chat.useCustomizationsInParentRepositories` setting.
- Mention `chat.instructionsFilesLocations` only when the project intentionally wants instructions outside `.github/instructions/`.