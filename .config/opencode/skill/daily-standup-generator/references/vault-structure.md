# Vault Structure

Development vault location and file conventions.

## Paths

| Item | Path |
|------|------|
| Vault root | `~/vaults/development/` |
| Daily notes | `~/vaults/development/daily_notes/YYYY/Month/YYYY-MM-DD.md` |
| Daily updates | `~/vaults/development/daily_updates/YYYY-MM-DD-standup.md` |
| Templates | `~/vaults/development/templates/` |

## Month Folder Names

Full English month name, capitalized: `January`, `February`, `March`, etc.

## Daily Note Frontmatter

```yaml
---
created: "YYYY-MM-DD"
tags:
  - daily
---
```

## Daily Note Section Headings

Headings use emoji prefixes. Match on the text after the emoji:

```
## Focus
## Incoming
## Work
## Decisions
## Open Loops
## Delivered
## Notes
```

Each heading has an italic subtitle line (e.g. `_What would make today a win?_`) that should be ignored during extraction.

## Task Syntax

Both `+` and `-` prefixes are used for checkboxes:

| Syntax | Meaning |
|--------|---------|
| `- [x]` | Completed task |
| `- [ ]` | Pending task |
| `+ [x]` | Completed task (alt) |
| `+ [ ]` | Pending task (alt) |
| Indented lines below | Sub-notes for the preceding task |

## Blockquote Convention

Lines starting with `>` are follow-up context or addendums to the preceding content. They represent later-in-the-day updates to something written earlier. Fold into the same logical item when summarizing.
