# Changelog

All notable changes to this project will be documented in this file.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

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
