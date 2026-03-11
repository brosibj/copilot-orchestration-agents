# Research: {TASK_ID}

**Slug:** `{task-slug}` · **Date:** {date} · **Type:** Feature | Bug

> **No code in artifacts.** Reference code by file path + line. Small pseudocode only when essential for clarity.

---

## Summary
> 2-3 sentence overview of what was discovered and the recommended approach.
> *Written by: `@requirements-builder`*

## Requirements

### Functional
- **FR-1:** {requirement}
- **FR-2:** {requirement}

### Non-Functional
- **NF-1:** {constraint}

### Acceptance Criteria
- [ ] {criterion}

## Technical Analysis
> *Written by: `@researcher` (compiled from fragments)*

### Affected Components
| Component | File(s) | Impact |
|:---|:---|:---|
| {Service/Page/Model} | {path} | {what changes} |

### Current Behavior
> Brief description of how the system works today. Reference code by file path + line, not by pasting blocks.

### Root Cause (bugs only)
> What's broken and why. 2-3 sentences with file references. Omit if not a bug.

## Findings

### Approach
> Recommended implementation approach. Reference existing patterns in the codebase.

### Dependencies
> New packages or capabilities needed. If none, state "None."
> ⚠️ New packages require user approval before planning.

### Risks
- {risk and mitigation}

## Bug Triage (bugs only)
- **Tier:** Medic | Detective | Specialist | Forensic
- **Confidence:** High | Medium | Low
- **Rationale:** {why this tier}
- **Escalation triggers:** {when to escalate}

## Build Baseline
> Captured before implementation begins. Lets validators distinguish new issues from pre-existing ones.

- **Warnings:** {count} pre-existing (run the project build command)
- **Failing tests:** {count} pre-existing (run the project test command)
