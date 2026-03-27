# Copilot Orchestration Agents

A GitHub Copilot agent template repository for workflow-centric orchestration packages.

## Overview

This repository contains authored workflow packages under `workflows/` and the runtime-facing `.github/` surface used for adoption and release bundles.

The top-level repository documentation is intentionally workflow-agnostic. Workflow-specific behavior, agents, prompts, and artifact models are documented separately:

- [docs/workflows-coding.md](docs/workflows-coding.md)
- [docs/workflows-project.md](docs/workflows-project.md)

## Common Repo Model

Each workflow package is self-contained and owns its own:

- agents
- shared rules
- templates
- prompts
- skills
- workflow-local instructions
- workflow-local automation or packaging files

## Repository Features

- workflow-family isolation
- workflow-local authoring under `workflows/{workflow-name}/`
- runtime-facing `.github/` layout for adoption
- release bundles that ship both `.github/` and `workflows/`
- support for workflow-specific prompts, templates, and skills without forcing a single orchestration model across the whole repository

## Workflow Packages

```text
workflows/
├── coding/
└── project/
```

Use the workflow-specific docs for package behavior:

- [docs/workflows-coding.md](docs/workflows-coding.md)
- [docs/workflows-project.md](docs/workflows-project.md)

## Getting Started

### 1. Choose the workflow package

Select the workflow package that matches the orchestration model you want to adopt or extend.

### 2. Review the workflow-specific documentation

Read the relevant workflow doc in `docs/` before customizing agents, prompts, or templates.

### 3. Customize active instructions in `.github/instructions/`

Project-specific standards continue to live in `.github/instructions/` using standard `*.instructions.md` files.

### 4. Update workflow-local assets only in the relevant package

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
├── coding/
└── project/
```

## What Lives Where

| Layer | Files | Purpose |
|:---|:---|:---|
| Runtime surface | `.github/**` | Runtime-facing layout for adoption and release output |
| Workflow source packages | `workflows/{workflow-name}/**` | Source-of-truth authoring location for each workflow family |
| Workflow docs | `docs/workflows-*.md` | Workflow-specific documentation |
| Project-specific active instructions | `.github/instructions/*.instructions.md` | Customization for an adopting repo |

## Release Bundles

Release bundles include both:

- the runtime `.github/` layout
- the workflow docs in `docs/`
- the authored `workflows/` source tree

