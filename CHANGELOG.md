# Changelog

All notable changes to this project will be documented in this file.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

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
