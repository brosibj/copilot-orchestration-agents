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
- Treat each suite's `agents/shared/workflow-rules.md` file as workflow-specific guidance for that suite's custom agents only. In release assets, those rules materialize under `.github/agents/shared/workflow-rules.md`. Do not assume prompts, skills, built-in agents, or unrelated custom agents automatically follow those rules unless they explicitly invoke that workflow.

## Repository Maintenance

- No new `.md` files without explicit direction or approval.
- Validate changes for regressions.