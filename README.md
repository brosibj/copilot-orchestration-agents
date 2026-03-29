# Copilot Orchestration Agents

A GitHub Copilot agent template repository for workflow-centric orchestration packages.

## Overview

This repository contains authored workflow packages under `workflows/` and the runtime-facing `.github/` surface used for adoption and release bundles.

`workflows/copilot-instructions.md` is the shared authored source for the global `.github/copilot-instructions.md` baseline. Workflow-specific agent behavior stays inside each package under `workflows/{workflow-name}/`.

The top-level repository documentation is intentionally workflow-agnostic. Workflow-specific behavior, agents, prompts, and artifact models are documented separately:

- [docs/workflows-coding.md](docs/workflows-coding.md)
- [docs/workflows-project.md](docs/workflows-project.md)

## Common Repo Model

The repository uses one shared global Copilot baseline plus workflow-local packages.

Each workflow package owns its own:

- agents
- shared rules
- templates
- prompts
- skills
- workflow-local instructions
- workflow-local automation or packaging files

The shared global baseline lives at `workflows/copilot-instructions.md`.

## Repository Features

- workflow-family isolation
- workflow-local authoring under `workflows/{workflow-name}/`
- runtime-facing `.github/` layout for adoption
- release bundles that ship both `.github/` and `workflows/`
- support for workflow-specific prompts, templates, and skills without forcing a single orchestration model across the whole repository

## Workflow Packages

```text
workflows/
├── copilot-instructions.md
├── coding/
└── project/
```

Use the workflow-specific docs for package behavior:

- [docs/workflows-coding.md](docs/workflows-coding.md)
- [docs/workflows-project.md](docs/workflows-project.md)

## Getting Started

### 1. Install the shared global baseline

Use `workflows/copilot-instructions.md` as the authored source for the runtime `.github/copilot-instructions.md` file. This gives built-in VS Code agents and custom agents the same always-on baseline.

### 2. Choose the workflow package

Select the workflow package that matches the orchestration model you want to adopt or extend.

### 3. Review the workflow-specific documentation

Read the relevant workflow doc in `docs/` before customizing agents, prompts, or templates.

### 4. Customize active instructions in `.github/instructions/`

Project-specific standards continue to live in `.github/instructions/` using standard `*.instructions.md` files.

### 5. Update workflow-local assets only in the relevant package

Prefer editing the source-of-truth under `workflows/{workflow-name}/` rather than treating `.github/` as the authored location for repo maintenance.

## Repository Structure

```text
.github/
├── agents/
├── instructions/
├── prompts/
├── skills/
├── workflows/
└── copilot-instructions.md

docs/
├── workflows-coding.md
└── workflows-project.md

workflows/
├── copilot-instructions.md
├── coding/
└── project/
```

## Instruction Layers

| Layer | Authored Source | Runtime Target | Applies To |
|:---|:---|:---|:---|
| Global baseline | `workflows/copilot-instructions.md` | `.github/copilot-instructions.md` | All Copilot requests, including built-in VS Code agents |
| Workflow rules | `workflows/{workflow-name}/agents/shared/workflow-rules.md` | `.github/agents/shared/workflow-rules.md` | Only the custom agents and workflows shipped by that package |
| Project-specific instructions | `.github/instructions/*.instructions.md` | `.github/instructions/*.instructions.md` | Any request whose `applyTo` scope matches |

## What Lives Where

| Layer | Files | Purpose |
|:---|:---|:---|
| Runtime surface | `.github/**` | Runtime-facing layout for adoption and release output |
| Shared global baseline | `workflows/copilot-instructions.md` | Authored source for `.github/copilot-instructions.md` |
| Workflow source packages | `workflows/{workflow-name}/**` | Source-of-truth authoring location for each workflow family |
| Workflow docs | `docs/workflows-*.md` | Workflow-specific documentation |
| Project-specific active instructions | `.github/instructions/*.instructions.md` | Customization for an adopting repo |

## Release Bundles

Release bundles include both:

- the runtime `.github/` layout
- the workflow docs in `docs/`
- the authored `workflows/` source tree

During bundle creation, `workflows/copilot-instructions.md` is copied into `.github/copilot-instructions.md` so the packaged runtime surface uses the shared global baseline.

