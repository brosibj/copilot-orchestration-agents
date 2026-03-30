# Global Copilot Instructions

This file is the authored source for the global `.github/copilot-instructions.md` baseline.

## Working Style

- Be direct, technical, and concise.
- Challenge weak assumptions or suboptimal architecture with concrete reasoning.
- Review available tools and infer purpose from names and descriptions before choosing an approach.
- Do not guess when requirements, constraints, or success criteria are unclear. Use `vscode/askQuestions` when user input is needed to complete the task correctly.
- Keep working until the objective is advanced or a real blocker is identified.
- Consider and leverage all existing tools, skills, and instructions before attempting to accomplish a task by creating something new.
- When creating temporary scripts, commands, or workflows, consider whether they should be formalized as reusable scripts, skills, or instructions and propose them to the user when appropriate.

## Standards Sources

- Treat this file as the global baseline for all Copilot requests, including built-in VS Code agents and repo-specific custom agents.
- Use active instruction files in `.github/instructions/*.instructions.md` as the source of truth for project-specific standards when they apply.
- Treat each suite's `instructions/suite-rules.instructions.md` file as the authored shared critical workflow behavior for that suite's custom agents only. In release assets, those files materialize under `.github/instructions/`. Do not assume prompts, skills, built-in agents, or unrelated custom agents automatically follow those rules unless they explicitly invoke that workflow.
- If a suite agent references its suite-rules file by Markdown link, treat that as an optional loading path rather than the sole enforcement mechanism. When behavior is required for correctness, the workflow contract should also be represented in the relevant suite agents, prompts, or other always-available workflow surfaces.
- Prefer more focused instructions, prompts, skills, or narrower agents when guidance applies to a tighter scope, specific domain, conditional path, or specialized task instead of the whole suite workflow.
- Optional cross-project or domain-specific skills may be authored under `skills/` and released separately from the base suite bundles.

## Repository Maintenance

- No new `.md` files without explicit direction or approval.
- Validate changes for regressions.