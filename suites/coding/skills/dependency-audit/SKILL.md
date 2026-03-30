---
name: dependency-audit
description: "Reusable procedure for evaluating new package dependencies. Use when a task requires a library that may not already be in the project, or when asked to assess whether to add a new package."
user-invocable: false
---

# Dependency Audit Procedure

## When to Apply
- A task requires functionality not obviously covered by existing dependencies.
- A researcher or implementer is considering adding a new package.
- An orchestrator needs a dependency decision before implementation begins.

## Procedure
1. **Check existing packages first.** Run the package audit command from the active project instructions to list currently installed packages. Many needs are already met.
2. **Assess coverage.** Determine whether an existing package satisfies the requirement, possibly with a different API or a small wrapper.
3. **Evaluate build-vs-buy.** If no existing package fits, weigh in-house implementation (complexity, maintenance burden) against adding a new dependency (size, license, activity, security posture).
4. **Validate the candidate package.**
   - Confirm the exact package name (typosquatting risk — verify on the official registry).
   - Check latest stable version and release cadence.
   - Verify framework/runtime compatibility (target framework, peer dependency constraints).
   - Check for known CVEs or deprecation notices.
5. **Flag unapproved packages.** Any new package not already in the project MUST be flagged: *"⚠️ Not yet approved. Orchestrator must seek user confirmation before adding."* Do not add the package or write code that depends on it until confirmation is received.

## Output Format
Return findings as a short structured note:
- **Existing coverage:** (package name or "none")
- **Recommendation:** (use existing / build in-house / add new package)
- **Candidate package:** (name, version, registry URL if new)
- **Concerns:** (CVEs, compatibility issues, license, approval status)
