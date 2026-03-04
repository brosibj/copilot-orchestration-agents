# Changelog

All notable changes to this project will be documented in this file.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

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
