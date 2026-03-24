---
name: daily-standup-generator
description: Generate a standup report from Obsidian daily notes in the development vault. Use when asked to generate a standup, daily update, or standup report.
---

# Daily Standup Generator

Read yesterday's and today's daily notes from the development vault and produce a standup report written to the `daily_updates/` folder.

## Vault Layout

```
~/vaults/development/
  daily_notes/YYYY/Month/YYYY-MM-DD.md   # source
  daily_updates/YYYY-MM-DD-standup.md     # output
  templates/daily_note.md                 # note template
```

## Workflow

1. **Resolve dates** - determine today's date and yesterday's date (previous weekday; skip Sat/Sun)
2. **Derive month folders** from each date (full English name, e.g. `March`, `April`)
3. **Read yesterday's note** at `~/vaults/development/daily_notes/YYYY/Month/YYYY-MM-DD.md`
4. **Read today's note** at the same path pattern for today's date
5. **Extract content** from each section (see Daily Note Sections below)
6. **Map sections to standup fields** using the mapping table
7. **Create output dir** if `daily_updates/` doesn't exist
8. **Write the standup** to `~/vaults/development/daily_updates/YYYY-MM-DD-standup.md`

If neither note exists, inform the user and stop. If only one exists, generate with available data and note which is missing.

## Daily Note Sections

Section headings use emoji prefixes (e.g. `## 🎯 Focus`). Match on the **text after the emoji**.

| Section | Content |
|---------|---------|
| Focus | Today's goals (task checkboxes) |
| Incoming | Unplanned work added during the day |
| Work | What moved forward |
| Decisions | Choices made and rationale |
| Open Loops | Unresolved items |
| Delivered | Completed deliverables |
| Notes | General observations |

Each heading has an italic subtitle line (e.g. `_What would make today a win?_`) -- ignore it during extraction.

## Section-to-Standup Mapping

| Standup Field | Source Note | Source Sections | Guidance |
|---------------|------------|-----------------|----------|
| **Yesterday** | Yesterday's note | Delivered, Work, Decisions | Summarize completed work and key decisions. Pull from Delivered first, then Work for items that moved forward. Include significant decisions. |
| **Today** | Today's note | Focus, Incoming (non-blocking) | List today's goals from Focus. Include Incoming items that are new work but not blocked on others. |
| **Blockers** | Both notes | Open Loops (both), Incoming (blocking) | Unresolved items from yesterday that carried over. Today's items waiting on other people/teams. |

### Classifying Incoming Items

Incoming items serve double duty. Use this heuristic:

- **Blocker**: contains explicit dependencies ("waiting on", "need X from Y", "blocked by", "once we have", "follow up with")
- **Today**: all other pending Incoming items (new work without stated dependencies)

## Output Rules

- 3-5 bullet points max per standup field
- First person; past tense for Yesterday, present/future for Today
- Strip Obsidian body syntax (wikilinks in frontmatter are fine)
- Blockquotes (`>`) are follow-up context for the preceding item -- fold into the same bullet
- Preserve names and team references exactly as written
- Narrative paragraphs: distill into single bullets capturing key action/outcome; keep specifics (names, teams, endpoints), drop conversational filler
- **Section placement > checkbox state**: an unchecked `- [ ]` under Delivered is still treated as completed
- Checkbox items: `- [x]`/`+ [x]` = completed, `- [ ]`/`+ [ ]` = pending
- Indented lines below a checkbox are sub-notes; fold into the parent bullet
- If a standup field has no source content, write "None"

## Output Template

See [standup-template.md](./assets/standup-template.md) for the exact output format.

## Edge Cases

| Scenario | Action |
|----------|--------|
| Neither note exists | Report to user, do not generate |
| Only one note exists | Generate with available data, note which is missing |
| Section empty | Write "None" for corresponding standup field |
| Very long notes | Summarize aggressively, keep to 3-5 bullets per field |
| Blockquote addendums (`>`) | Fold into preceding logical item (bullet, paragraph, or checkbox) |
| Output dir missing | Create `daily_updates/` before writing |
| Monday standup | Yesterday = Friday's note |

## In This Reference

| File | Purpose |
|------|---------|
| [vault-structure.md](./references/vault-structure.md) | Vault paths, note format, frontmatter |
| [standup-template.md](./assets/standup-template.md) | Output template |
