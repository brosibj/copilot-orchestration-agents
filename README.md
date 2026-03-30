# Copilot Orchestration Agents

A GitHub Copilot suite repository for reusable orchestration setups.

## Overview

This repository contains authored suites under `suites/`. Repo-level automation under `.github/workflows/` assembles those authored suites into installable release assets.

`suites/copilot-instructions.md` is the shared authored source for the global `.github/copilot-instructions.md` baseline. Suite-specific behavior stays inside each suite under `suites/{suite-name}/`.

The top-level repository documentation is intentionally suite-agnostic. Suite-specific behavior, agents, prompts, instructions, skills, and artifact models are documented separately:

- [docs/suites-coding.md](docs/suites-coding.md)
- [docs/suites-project.md](docs/suites-project.md)

## Common Repo Model

The repository uses one shared global Copilot baseline plus suite-local source directories.

Each suite owns its own:

- agents
- shared rules
- templates
- prompts
- skills
- suite-local instructions

Optional, separately installable skills live under `skills/`.

The shared global baseline lives at `suites/copilot-instructions.md`.

## Repository Features

- suite isolation
- suite-local authoring under `suites/{suite-name}/`
- optional cross-project skills under `skills/`
- shared global baseline for built-in and custom agents
- installable release assets that ship ready-to-copy `.github/` folders per suite
- support for suite-specific prompts, templates, and skills without forcing a single orchestration model across the whole repository

## Suites

```text
suites/
├── copilot-instructions.md
├── coding/
└── project/
```

Use the suite-specific docs for behavior details:

- [docs/suites-coding.md](docs/suites-coding.md)
- [docs/suites-project.md](docs/suites-project.md)

## Quick Start

### 1. Download the release asset for the suite you want

- `copilot-suite-coding-<tag>.zip` — coding orchestration for implementation, debugging, migrations, validation, and PR closure
- `copilot-suite-project-<tag>.zip` — project orchestration for research, planning, writing, coordination, and bounded automation
- `copilot-skills-<tag>.zip` — optional domain-specific skills that you can merge into an existing Copilot setup when needed

### 2. Copy the included `.github/` folder into your repo root

Each release asset contains a ready-to-copy `.github/` folder for that suite plus the shared global `copilot-instructions.md` baseline.

If you want optional skills, also merge the `.github/skills/` folder from `copilot-skills-<tag>.zip`.

### 3. Open the repo in VS Code and run `/align-project`

Both installable suites include `align-project` as the setup and resync entry point.

### 4. Answer the setup questions and let the suite seed `.github/instructions/`

Project-specific standards continue to live in `.github/instructions/` using standard `*.instructions.md` files.

### 5. Start with the suite-specific prompts

- Coding suite: `/new-feature`, `/quick-fix`, `/bug-report`
- Project suite: `/project-update`, `/quick-project`

Review the relevant suite doc before deeper customization:

- [docs/suites-coding.md](docs/suites-coding.md)
- [docs/suites-project.md](docs/suites-project.md)

## Repository Structure

```text
.github/
├── copilot-instructions.md
├── instructions/
├── skills/
└── workflows/

docs/
├── suites-coding.md
└── suites-project.md

skills/
└── blazor-js-interop-disposal/

scripts/
└── build-release-assets.ps1

suites/
├── copilot-instructions.md
├── coding/
└── project/
```

The source repo keeps `.github/` minimal. The full installable `.github/agents` and `.github/prompts` surfaces are materialized per suite in the release assets.

## Instruction Layers

| Layer | Authored Source | Runtime Target | Applies To |
|:---|:---|:---|:---|
| Global baseline | `suites/copilot-instructions.md` | `.github/copilot-instructions.md` | All Copilot requests, including built-in VS Code agents |
| Suite rules | `suites/{suite-name}/agents/shared/workflow-rules.md` | `.github/agents/shared/workflow-rules.md` | Only the custom agents and orchestration shipped by that suite |
| Project-specific instructions | `.github/instructions/*.instructions.md` | `.github/instructions/*.instructions.md` | Any request whose `applyTo` scope matches |

## What Lives Where

| Layer | Files | Purpose |
|:---|:---|:---|
| Repo automation | `.github/workflows/release.yml` | Creates tags and assembles installable suite assets from `suites/` and optional skill assets from `skills/` |
| Release packaging script | `scripts/build-release-assets.ps1` | Shared release packaging logic for suite and optional-skill bundles |
| Shared global baseline | `suites/copilot-instructions.md` | Authored source for `.github/copilot-instructions.md` |
| Optional skills | `skills/**` | Source-of-truth for optional skills released as a separate `.github/skills` bundle |
| Suite sources | `suites/{suite-name}/**` | Source-of-truth authoring location for each suite |
| Suite docs | `docs/suites-*.md` | Suite-specific documentation |
| Project-specific active instructions | `.github/instructions/*.instructions.md` | Customization for an adopting repo |

## Release Assets

Each release publishes three installable assets:

- `copilot-suite-coding-<tag>.zip`
- `copilot-suite-project-<tag>.zip`
- `copilot-skills-<tag>.zip`

Each zip contains only a ready-to-copy `.github/` folder built from `suites/copilot-instructions.md` plus the selected suite's agents, prompts, skills, templates, and suite-local rules.

The optional skills zip contains a ready-to-copy `.github/skills/` folder built from `skills/`.

There is no single combined install bundle. The runtime `.github` namespace has suite collisions such as `Quick` and suite-specific shared files, so separate suite assets are the safest path for immediate installation.

