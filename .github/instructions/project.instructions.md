---
applyTo: '**'
description: Repository-specific guidance for maintaining the copilot-orchestration-agents source repo.
---

# Repository Guidance

## Audience And Docs

- Keep `README.md` adopter-facing. It should explain what a user downloads, installs, runs, and where to find suite docs.
- Put repo-maintainer design decisions, authoring conventions, packaging rules, and release mechanics in instruction files like this one instead of pushing them into the README.
- Keep suite docs user-facing as well. Use them for suite behavior and adoption details, not for internal maintenance rules unless the rule matters directly to suite authors.

## Source Of Truth

- Author reusable suites under `suites/{suite-name}/`.
- Author optional cross-project skills under `skills/`.
- Use `suites/copilot-instructions.md` as the authored source for `.github/copilot-instructions.md`.
- Treat release assets as generated outputs assembled from authored sources, not as the source of truth.
- When editing suite behavior, prefer suite-local files under `suites/{suite-name}/` over inventing new root-level structures.

## Release Model

- `.github/workflows/release.yml` is the single release workflow for this repo.
- `scripts/build-release-assets.ps1` owns bundle assembly logic. If packaging behavior changes, update the script first and keep the workflow thin.
- Release outputs are `copilot-suite-coding-<tag>.zip`, `copilot-suite-project-<tag>.zip`, and `copilot-skills-<tag>.zip`.
- Do not reintroduce a combined suite bundle unless the runtime `.github` naming collisions between suites have been resolved.

## Suite Boundaries

- `suites/coding/` is the phase-based coding orchestration suite.
- `suites/project/` is the open-ended project orchestration suite.
- Keep suite-local agents, prompts, templates, instructions, and skills self-contained.
- Avoid cross-contaminating the project suite with coding-only phase assumptions.
- Cross-project or optional capabilities should usually live under top-level `skills/`, not inside one suite, unless they are part of that suite's core contract.

## Instructions Model

- `.github/copilot-instructions.md` is the global baseline. Keep it aligned with `suites/copilot-instructions.md` and avoid accumulating repo-specific maintenance rules there. Changes to this file should be rare and reserved for global behavior that truly applies to all agents, not just suite agents introduced by this repo.
- When asked to implement a new behavior, assume it should be localized to a specific suite. Only modify this project's (`.github`) if explicitly requested. Contents in `.github` don't get published as part of the suite bundles. 
- Repo-specific behavior belongs in `.github`.
- Suite-only behavior lives in `suites/{suite-name}`.
- Each suite's `suite-rules.instructions.md` file is the authored shared critical workflow behavior for that suite.
- Suite agents may reference those rules by Markdown link, but that is an optional loading path rather than the only enforcement mechanism.
- When workflow behavior is required for correctness, make sure the relevant suite agents, prompts, or other always-available workflow surfaces also carry that contract.
- Do not put guidance that belongs to a narrower scope or domain into a suite-wide `suite-rules.instructions.md` file when a more focused prompt, skill, or instruction file can carry it instead.
- Do not rely on referenced instructions being available; assume they are off unless the current environment has been explicitly verified.

## Reuse And Formalization

- Reuse existing suites, prompts, skills, templates, instructions, and scripts before adding new assets.
- When setup, packaging, or release logic becomes reusable, move it into a maintained script or authored source instead of duplicating it in YAML or docs.
- If a repo-level convention starts showing up in multiple places, centralize it here or in the authored suite sources instead of letting it drift.

## Useful File Map

- `docs/suites-coding.md` and `docs/suites-project.md` are adopter-facing suite docs.
- `.github/workflows/release.yml` and `scripts/build-release-assets.ps1` define the release/build path.
- `suites/copilot-instructions.md` defines the authored global baseline.