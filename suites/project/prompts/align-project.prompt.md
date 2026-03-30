---
agent: 'agent'
description: "Align this repo's project-suite customization to the current project state."
tools: [read, edit, search, vscode]
---

You are aligning this repository's GitHub Copilot project-suite customization to the current adopting project.

## Behavior

- **First run:** gather project-work facts, then create or populate the active instruction file.
- **Re-run:** read the current file first; update only what changed or is incomplete. Never overwrite content the user intends to keep.

## Step 1 — Gather Project-Work Facts

Attempt to determine answers to all questions below from the repo's existing files. If any are missing, use `vscode/askQuestions` to collect the missing information in as few batches as possible. Iterate until all questions are answered:

1. **Project type:** What kind of work does this suite support here? (e.g. internal initiative, client delivery, product discovery, operations rollout)
2. **Audience:** Who is the primary audience for the outputs? (e.g. engineering leadership, product team, stakeholders, customers)
3. **Primary outputs:** What should the suite optimize for? (e.g. briefs, plans, issue batches, SOPs, rollout checklists)
4. **Decision style:** How should options and tradeoffs be presented? (e.g. recommend one option, escalate unresolved tradeoffs)
5. **Status cadence:** How often should project state be refreshed? (e.g. every loop refresh summary.md and add a concise worklog/NNN-topic.md entry)
6. **Approval model:** What actions require explicit approval? (e.g. irreversible issue writes, external changes)
7. **Issue hygiene:** How should issues be structured and labeled, if relevant?
8. **Allowed automation:** What bounded automation is allowed?
9. **Restricted automation:** What automation is off-limits without approval?

## Step 2 — Update Files

Using the project info and answers, update or create the following files from their template. For each, read the current file first if it exists.

### `.github/instructions/project.instructions.md` from `.github/agents/templates/project.instructions.template.md`
- Set `applyTo: '**'`
- Populate domain, audience, primary outputs, working norms, and automation guardrails.

### `.github/copilot-instructions.md`
- Keep the global baseline intact.
- Update only project-standard references when needed.

## Step 3 — Confirm

If any additional information is needed to fully complete the files, use `vscode/askQuestions` to clarify. Iterate until the setup is complete and consistent with the project facts.

Once completed, list each file modified or created, and any gaps that couldn't be answered from the provided information.

After that file summary, ALWAYS end your response with this exact section:

## Enable Nested Subagents
Nested suite workflows require the VS Code setting `chat.subagents.allowInvocationsFromSubagents`, which is off by default.

Enable it in either place:
1. Settings UI: press `Ctrl+,`, search for `allow invocations from subagents`, and enable **Chat > Subagents: Allow Invocations From Subagents**.
2. Settings JSON: run **Preferences: Open Workspace Settings (JSON)** for this repo only, or **Preferences: Open User Settings (JSON)** for all repos, then add:

```json
"chat.subagents.allowInvocationsFromSubagents": true
```

Workspace settings are the safer default for a shared repo. User settings are fine if you want nested subagents enabled everywhere.
