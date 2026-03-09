# Changelog

All notable changes to this project will be documented in this file.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.4.0] - 2026-03-09

### Added
- **Instruction-first standards layer** — active `.github/instructions/*.instructions.md` files now carry project, testing, styleguide, and Blazor JS interop guidance directly, with matching `.template` files available as seeds for new repos.
- **LSP tooling upgrades** — VS Code 1.110 `search/usages` support is available to implementers, reviewers, planners, and researchers, `edit/rename` is wired into the implementer agents, and diagnostics now flow through `read/problems` so validators, debuggers, and implementers can inspect workspace issues directly.
- **Reusable skills** — `artifact-management`, `dependency-audit`, and `blazor-js-interop-disposal` capture reusable procedures without relying on `.github/docs` references.
- `.github/docs` has been removed in favor of using either `*.instructions.md` or `SKILL.md` files as applicable.
- **Slash prompts, validator browser tools, and session guidance** — `/init-project`, `/bug-report`, `/new-feature`, and `/quick-fix` routes simplify common workflows, the validator can now open/read/navigate/click/screenshot UI pages when warranted, and the shared `workflow-rules.md` adds a Session Management section covering when and how to run `/compact` while preserving artifact data.
- **P2 retry exhaustion behavior** — after 5 failed retries `@build` writes `report.md` with the final failing verdict and surfaces three options to the user via `vscode/askQuestions`: continue manually, restart from `@discover` with revised requirements, or abandon task.
- **`report.md` retry guidance in `artifact-management` skill** — documents overwrite-on-retry semantics: include notable prior findings only, avoid accumulating full retry history.

### Changed
- **Instruction loading model** — agents, shared templates, prompts, skills, README, and `copilot-instructions.md` now reference auto-loaded instruction files instead of `.github/docs` paths.
- **Complexity gate moved post-discovery** — `@requirements-builder` now returns a **complexity classification** (Simple/Standard) based on actual codebase analysis. P1 routes after discovery instead of pre-classifying before `@requirements-builder` runs.
- **`@quick` PR step** — step 5 is now search-only (note existing PR URL); step 6 asks user to choose create/update/skip instead of auto-updating an existing PR.
- **Instruction template files relocated** — `*.instructions.template.md` seeds moved from `.github/instructions/` to `.github/agents/templates/` alongside the existing artifact templates. `/init-project` references updated accordingly.
- **`errata-patterns` skill and `errata/` directory replaced** — deleted the `errata-patterns` meta-skill and `.github/errata/` directory; `blazor-js-interop-disposal` converted to a proper standalone `skills/blazor-js-interop-disposal/SKILL.md`. All agent references updated from errata to skills.
- **README overhaul** — structure diagram rebuilt to reflect template moves, skills changes, and empty `instructions/` note; P1 workflow description updated to match new complexity gate; P2 retry count corrected to 5; adoption sections merged with `/init-project` as the recommended first step; artifact protocol clarified as ephemeral/git-ignored.

### Fixed
- **Missing YAML frontmatter delimiter** — 10 agent files (`researcher`, `planner`, `implementer`, `implementer-ui`, `implementer-service`, `reviewer`, `debugger-medic`, `debugger-detective`, `debugger-specialist`, `debugger-forensic`) were missing the opening `---` line, causing frontmatter to render as body text.

## [1.3.0] - 2026-03-08

### Added
- **`edit` tool on P1** — orchestrator can now create `{task-slug}/` directories and seed files without delegating.
- **`renderMermaidDiagram` tool on `@planner`** — enables execution-flow and architecture diagram generation during planning.
- **`radzen.mcp/*` tool on `@debugger-detective`** — UI-framework debugger can now verify Radzen component behavior.
- **Confidence gate (>85% overall, 90% per-topic)** in `workflow-rules.md` — replaces vague "~85%" language with hard thresholds and per-topic evaluation.
- **Question batching guidance** in `workflow-rules.md` — agents must batch up to 4 questions per `askQuestions` call to minimize round trips.
- **Deferred issue approval prompt** in P3 — orchestrator presents multi-select `askQuestions` for user to approve which deferred items become GitHub issues. Replaces silent auto-creation.
- **PR create/update/skip question** in P3 and `@quick` — user chooses: create new PR, update existing (with PR #), or skip. Replaces bare yes/no confirmation.
- **Dynamic `pr.md` template** — sections are conditional based on example `project.md` and example `testing.md` configuration. Includes size guide (Compact/Standard), Linked Issues table, and GitHub issue cross-references.
- **Bug path now consistent with feature path** in P1 — `@requirements-builder` runs first for bugs (was already step 1 for features), ensuring `research.md` exists before `@triage` reads it.
- **P3 PR description via `@researcher` summarize** — orchestrator dispatches `@researcher` to read `pr.md` content instead of reading it directly (respects orchestrator constraints).
- **Orchestrator Constraints** in `workflow-rules.md` — orchestrators must not read file contents (existence checks only); all content-based routing via subagent return summaries. `@quick` exempt as hybrid worker.
- **Platform Constraints** in `workflow-rules.md` — documents that subagents cannot invoke other subagents; only orchestrators dispatch.
- **Return Protocol** in `workflow-rules.md` — concise structured return format guidance for subagent-to-orchestrator communication to prevent context bloat.
- **Fragment pattern** for parallel research — `@researcher` instances write to `{task-slug}/fragments/{scope-name}.md`, then a compile pass merges into `research.md`.
- **Build & Test Commands** section in example `testing.md` — test commands and gates consolidated as single source of truth for test configuration.
- **No-code artifact guidance** — `workflow-rules.md` and `research.md` template enforce referencing code by file path + line instead of pasting blocks.
- **Suggested research scopes** — `@requirements-builder` now returns suggested research scopes for orchestrator to dispatch parallel researchers.
- **Pre-flight summarization** — `@build` and `@finalize` dispatch `@researcher` with summarize scope for routing info instead of reading artifacts directly.

### Changed
- **Renamed `readme.md` template → `pr.md`** — avoids confusion with project root `README.md`. All cross-references updated (P3, `@quick`, `@deferred-tracker`, `copilot-instructions.md`, `.gitignore`, `README.md`).
- **Reworked P3 finalization workflow** — deferred issue creation now requires user approval (multi-select prompt); PR handling offers create/update/skip; `@deferred-tracker` writes `pr.md` with dynamic sections.
- **Merged `researcher` + `research-worker`** into a single generic `@researcher` agent. Supports three modes: research (write fragment), compile (merge fragments), summarize (return routing data). Eliminates nested subagent dispatch.
- **Reworked P1 Discovery workflow** — requirements-builder (serial, interactive) → parallel researchers (scoped) → compile researcher → planner. Replaces sequential researcher-with-nested-workers pattern.
- **Stripped tools from orchestrators** — P1, P2, P3 orchestrators no longer have `read`, `search`, `web`, or MCP tools. Routing delegated to subagents.
- **Strengthened `askQuestions` enforcement** — `copilot-instructions.md` and `workflow-rules.md` now mandate `vscode/askQuestions` over ending sessions. Added "Never end prematurely" rule.
- **Test configuration single source of truth** — moved `dotnet test` and Test DB entries from example `project.md` to example `testing.md`. Updated Docs Index and all cross-references.
- **Updated Docs Index** in `copilot-instructions.md` — split "build/test commands" between example `project.md` (build) and example `testing.md` (test).
- **`@requirements-builder` scoped** — now writes only Summary + Requirements + AC sections of `research.md`; Technical Analysis deferred to researchers.

### Removed
- **`research-worker.agent.md`** — merged into generic `@researcher`. Nested subagent dispatch eliminated.
- **Test DB from example `project.md`** — moved to example `testing.md` § Stack & Infrastructure.
- **`dotnet test` from example `project.md`** — moved to example `testing.md` § Build & Test Commands.

## [1.2.0] - 2026-03-04

### Added
- **New `project.md` file** — centralized project configuration for tech stack, build/test commands, migrations, coding standards, and data access patterns
- **Docs Index in `copilot-instructions.md`** — quick reference table for accessing project-specific documentation
- **Required References sections** in agent files — each agent now explicitly lists the project docs it needs to enforce
- **Component Data Access Patterns** in `styleguide.md` — formalized patterns for UI component context usage (`OwningComponentBase`, `IDbContextFactory`)
- **MCP Tool Guidance section** in `project.md` — optional structure for agents to understand when to use project-specific tools

### Changed
- **Renamed `dispatch-rules.md` → `workflow-rules.md`** — updated all agent references and clarified shared coordination patterns
- **Framework abstraction throughout** — replaced specific references (Blazor → UI framework, EF Core → ORM) to improve template portability
- **Simplified agent instructions** — removed "Opus agent — single-instance only" language; unified build/test verification to reference `project.md` § Build & Validation
- **Restructured README** — consolidated tech stack tables into `project.md` as single source of truth; expanded debugging tier information and model assignment rationale
- **Updated agent frontmatter** — added "Required References" section to agents that need specific project docs
- **Streamlined debugging tier scoping** — moved to `project.md` for per-project customization via triage

### Removed
- **Opus model constraints table** — unified into coordination guidance in `workflow-rules.md`
- **Explicit package/framework/tech stack references** — replaced with generic terms to reduce framework-specific coupling
- **`dbcontext-patterns.errata.md`** — DbContext patterns moved to `styleguide.md` § Component Data Access Patterns

## [1.1.2] - 2026-03-03
- build changes

## [1.1.1] - 2026-03-03
- build changes


## [1.1.0] - 2026-03-03

### Added
- **Features section** in `README.md` documenting workflow benefits, preventative measures, and when to adapt the template
- **"Referenced in" column** to all package and tool tables in `README.md` for transparency and traceability
- **Expanded test project types** in `testing.md`: added `E2ETests` and `ComponentTests` project variants

### Changed
- **Renamed orchestrator agent files** for clarity: `discover.agent.md` → `P1.discover.agent.md`, `build.agent.md` → `P2.build.agent.md`, `finalize.agent.md` → `P3.finalize.agent.md`
- **Simplified dependency audit guidance** in `researcher.agent.md`: replaced explicit package name examples with framework-agnostic "pre-existing libraries" approach
- **Removed outdated test exclusions** in `testing.md`: removed deferred UI/Radzen/Identity testing restrictions (superseded by current project context)
- **Updated file references** throughout README tables to reflect renamed agent files

### Fixed
- **Clarified framework compatibility language** in `researcher.agent.md`: changed ".NET 10 compat" to generic "framework compatibility" for project adaptability

## [1.0.0] - 2026-03-02

### Added
- `@quick` orchestrator for single-pass flows on simple tasks (≤ 3 files, no migrations, no new deps)
- Purpose-built implementer sub-agents (`@implementer`, `@implementer-ui`, `@implementer-service`) replacing generic addendum approach
- Model assignments table and workflow overview in `README.md`
- `.gitignore` coverage for generated plan artifacts

### Changed
- Renamed orchestrators for clarity and consistency across the pipeline
- Restructured agent files to minimize token usage and reduce context overhead
- Compacted agent prompts for reduced context window consumption
- Simplified context passing and artifact creation across workflow phases
- Closed open loops in handoff sequences for `@discover` → `@build` → `@finalize`
- Preferred `dotnet` CLI commands over manual project file edits; clarified agent action scope
- Updated permitted tool lists across agents
- Refined model assignments for service-layer work

### Removed
- Azure MCP tool references
- Defunct product/package references
