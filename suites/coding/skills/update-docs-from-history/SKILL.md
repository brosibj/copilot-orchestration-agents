---
name: update-docs-from-history
description: 'Update project README, CHANGELOG, workflow docs, prompts, instructions, and related internal docs by analyzing git diffs, branch history, commit ranges, or GitHub PR context. Use to synchronize documentation with recent code changes.'
argument-hint: 'What docs should be updated from which history or PR context?'
user-invocable: true
---

# Update Docs From History

## What This Skill Does

Turns a history-based documentation request into targeted, proportional doc updates.

It helps the agent:
- choose the correct history window
- infer which existing docs should change
- use PR context only as supplemental input
- keep documentation effort proportional to the actual changes
- bridge raw git activity to repository documentation without inventing unsupported rationale

## Scope Rules

- Prefer updating existing documentation over creating new documentation.
- Do not create a new `.md` file unless the user explicitly asks for it or the repository already uses an equivalent documentation pattern that clearly requires a new file.
- Match the existing vocabulary, tone, and level of technical precision in the repository.
- If the user names target docs, treat those as the primary scope.
- If the user does not name target docs, infer them from both the change set and the repository's existing documentation patterns.
- If confidence is low about which docs should change, ask a focused follow-up instead of guessing broadly.
- Do not delete existing content unless the underlying behavior is clearly obsolete or replaced.
- Do not include raw commit hashes, internal IDs, or PR-only metadata in public-facing docs unless the repository already uses that pattern.

## History Source Selection

1. Use an explicit commit, tag, range, or branch comparison if the user provides one.
2. If the user says "changes in this branch not yet merged to main" or equivalent, compare `HEAD` against the merge-base with `main`.
3. If the user says "recent commits" or similar, clarify the window only when it materially affects the result. Otherwise use the narrowest reasonable range and state the assumption.
4. Use GitHub PR context only when requested, or after confirmation if there is a clearly matching open PR for the current changes.
5. Treat the local diff and commit history as the source of truth. Use PR descriptions, comments, and review discussion only to clarify intent or accepted wording.

## Documentation Targeting Rules

- Update `README.md` for user-facing capabilities, setup, workflow, or usage changes.
- Update `CHANGELOG.md` for release-note-worthy behavior changes when the repository maintains one.
- Update prompts, instructions, agents, or workflow docs when those assets or their documented behavior changed.
- Update narrower docs only when the changed files map clearly to that documented area.
- Skip doc changes for purely internal refactors unless the repository already documents those internals or the user explicitly asks.

## Proportionality Heuristics

- Small internal fix: brief note or no doc change.
- Small user-visible change: concise README or changelog update.
- Medium workflow or feature change: update the relevant README sections and directly affected prompts, agents, instructions, or workflow docs.
- Large workflow or capability change: refresh overview and affected procedures, but avoid duplicating implementation detail.
- Breaking change: update the most visible migration or breaking-change guidance already present in the repo.
- Infrastructure or CI change: update setup, automation, or workflow docs when contributor behavior changes.

## Procedure

1. Parse the request.
   - Identify the target docs, if any.
   - Identify the history source: branch diff, commit range, PR, or "since branching from main".
   - Identify whether GitHub read-only context was requested.
2. Collect the history.
   - Determine the comparison base.
   - Review commit subjects, changed files, and diffs only as deeply as needed to understand externally meaningful changes.
   - If the selected diff is unusually broad or ambiguous, summarize the intended doc changes first and confirm before editing.
3. Infer documentation targets.
   - Start with named docs.
   - Add existing docs that cover the changed behavior.
   - If confidence is low, ask a focused question instead of touching too many docs.
4. Decide the doc depth.
   - Compare change size and visibility against how thoroughly similar behavior is already documented in the repo.
   - Prefer the smallest accurate update that keeps docs current.
5. Use GitHub context when requested or confirmed.
   - Read PR title, body, changed files, and review discussion only as supplemental context.
   - Prefer the actual commits and diff over PR prose when they diverge.
6. Edit the docs.
   - Preserve the repository's structure and tone.
   - Keep wording factual, specific, and grounded in verified changes.
7. Validate.
   - Check that each new claim is supported by the selected history window or confirmed PR context.
   - Check that no major user-visible change in scope was omitted.
   - Check that the amount of documentation added is proportionate.

## Decision Points

Ask a focused follow-up only when one of these materially changes the result:

- the base branch is unclear and the repository uses something other than `main`
- the selected diff is broad enough that a dry-run summary is needed before making doc edits
- the user did not say whether to update only a named doc or all relevant docs
- the request mentions PR context but does not identify which PR and it cannot be inferred safely
- confidence is low when inferring documentation targets from the repo's existing documentation patterns
- the change set mixes unrelated work and the documentation should be split or narrowed

If the ambiguity is minor, make the narrowest reasonable assumption and state it briefly.

## Completion Criteria

The skill is complete when:

- the chosen history source matches the user's request
- the updated docs are limited to the areas justified by the verified changes
- the depth of the edits matches both the scale of the changes and the repo's current documentation style
- any GitHub-derived context is treated as supplemental, not a replacement for the actual diff
- the final summary states what docs were updated and what history window or PR context was used

## Example Prompts

- `/update-docs-from-history update the README based on changes in this branch not yet merged to main`
- `/update-docs-from-history use PR #12 as context to refresh the CHANGELOG`
- `/update-docs-from-history refresh all relevant docs based on the last 3 commits`
- `/update-docs-from-history refresh changelog and workflow docs based on commits since branching from main`