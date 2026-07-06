# Copilot Orchestration Agents

Reusable GitHub Copilot suites for installing structured coding and project workflows into a repository.

## What You Can Install

- `coding` suite: prompt-and-skill-based coding workflow for planning, implementation, validation, debugging, and PR wrap-up. See [docs/suites-coding.md](docs/suites-coding.md).
- `project` suite: open-ended project orchestration for research, planning, writing, coordination, and bounded automation. See [docs/suites-project.md](docs/suites-project.md).
- Optional skills: separately installable `.github/skills/` bundle for cross-project or domain-specific capabilities.

## Quick Start

1. Download the release asset you want:
	 - `copilot-suite-coding-<tag>.zip`
	 - `copilot-suite-project-<tag>.zip`
	 - `copilot-skills-<tag>.zip` if you want optional skills
2. Copy the included `.github/` folder into the root of your repository.
3. If you want optional skills, merge `.github/skills/` from `copilot-skills-<tag>.zip`.
4. Open the repository in VS Code and run `/align-project`.
5. Answer the setup questions, then start with the installed suite prompts or skills.
6. If you also install the `project` suite and its `/align-project` prompt asks for nested subagent support, enable `chat.subagents.allowInvocationsFromSubagents` at that time.

## Suite Entry Points

- Coding suite prompts: `/new-feature`, `/quick-fix`, `/bug-report`
- Coding suite phase prompts: `/discover-plan`, `/execute-plan`, `/finalize-task`
- Coding suite atomic skills can also be invoked directly when needed: planning, migration, validation, docs, and PR-prep skills under `.github/skills/`
- Project suite prompts: `/project-update`, `/quick-project`

Both suites include `/align-project` for initial setup and later resync.
The coding-suite `/align-project` now focuses on repo context layering for instructions, prompts, and skills.

## Release Assets

Each release publishes three installable assets:

- `copilot-suite-coding-<tag>.zip`
- `copilot-suite-project-<tag>.zip`
- `copilot-skills-<tag>.zip`

The suite bundles are published separately on purpose. They install into the same runtime `.github` namespace, so a single combined ready-to-copy bundle would introduce naming collisions between suite-specific agents, prompts, and shared files.

## Learn More

- [docs/suites-coding.md](docs/suites-coding.md) covers coding-suite behavior, prompts, and adoption details.
- [docs/suites-project.md](docs/suites-project.md) covers project-suite behavior, prompts, and adoption details.
- `copilot-skills-<tag>.zip` contains optional skills you can merge into either suite when needed.

