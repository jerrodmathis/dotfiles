---
name: pull-request
description: Generate pull request descriptions with JIRA ticket linking and structured changelogs. Use when creating a pull request, writing a PR description, or asked to open a PR.
---

# Pull Request

Generate structured PR descriptions with JIRA issue linking, concise change summaries, and test coverage notes.

## PR Description Format

```markdown
## Summary
<!-- One or two sentences. What does this PR do? -->

## Motivation
<!-- Why is this change needed? Link issue/ticket. -->

## Changes
- 
- 

## Testing
- 

## Notes for Reviewers
<!-- Anything to call out: tradeoffs, known issues, areas of uncertainty -->

## Screenshots (if applicable)
```

## Workflow

1. **Use git** for all VCS commands
2. **Gather context** — diff the current branch against base; read conventional commit messages
3. **Fill Summary** — 1-2 sentences describing what the PR does
4. **Fill Motivation** — JIRA link if ticket provided, otherwise short rationale
5. **Fill Changes** — derive from commit messages; fallback to logical groupings from diff
6. **Fill Testing** — list tests added/updated from diff; note absence if none
7. **Create PR** — use `gh pr create` with the formatted body

## Section Rules

### ## Summary

1-2 sentences describing what the PR does. Infer from the diff and commit messages. Focus on the outcome, not the implementation.

### ## Motivation

| Scenario | Content |
|----------|---------|
| Ticket number provided (e.g. `PROJ-123`) | `[PROJ-123](https://JIRA_BASE_URL/browse/PROJ-123)` |
| No ticket number | 1-2 sentence rationale explaining why the change is needed |

**JIRA link format:** `[TICKET-KEY](https://JIRA_BASE_URL/browse/TICKET-KEY)`

If the JIRA base URL is unknown, ask the user once and reuse for the session.

### ## Changes

- Derive bullets from conventional commit messages on the branch (strip prefixes like `feat:`, `fix:`, `refactor:` — use the message body only)
- Fallback to logical groupings from the diff when commits are not conventional
- Each bullet starts with a past-tense verb: Added, Fixed, Removed, Updated, Refactored, Replaced
- One bullet per logical change, not per file
- Group related file changes into a single bullet
- No implementation details — describe *what changed* not *how*
- Order: additions first, then modifications, then removals

| Good | Bad |
|------|-----|
| `Added rate limiting to /api/upload` | `Changed upload.ts` |
| `Fixed null pointer in user lookup` | `Added null check on line 42 of user-service.ts` |
| `Removed legacy OAuth1 support` | `Deleted oauth1.ts, oauth1-types.ts, oauth1-utils.ts` |
| `Updated error messages to include request ID` | `Modified error handling` |

### ## Testing

Scan the diff for test file changes (files matching `*.test.*`, `*.spec.*`, `__tests__/`, etc.) and list what was added or updated:

```markdown
## Testing
- Added unit tests for rate limiter edge cases
- Updated integration tests for /api/upload endpoint
```

If no test changes appear in the diff:

```markdown
## Testing
- No test changes
```

Do not add checkboxes. Keep it as a plain list of what exists in the diff.

### ## Notes for Reviewers

Ask the author what should be called out for reviewers — tradeoffs, known issues, areas of uncertainty, or follow-up work. Include their response. If the author has nothing to note, leave the HTML comment placeholder as-is.

### ## Screenshots (if applicable)

Omit this section entirely for clearly non-visual changes (e.g. backend logic, config, tooling). Keep it for anything touching UI.

## Constructing the Diff

Analyze **all commits** on the branch since divergence from base, not just the latest:

```bash
git log --oneline main..HEAD   # read commit messages for Changes section
git diff main...HEAD           # fallback for Changes; source for Testing section
```

Prefer commit messages for the Changes section — they represent the author's intent. Use the diff when commits are not descriptive or are squash candidates.

## Creating the PR

Use a heredoc to pass the body for correct formatting:

```bash
gh pr create --title "Short descriptive title" --body "$(cat <<'EOF'
## Summary
One or two sentences describing what this PR does.

## Motivation
[PROJ-123](https://jira.example.com/browse/PROJ-123)

## Changes
- Added new feature X
- Fixed bug in Y
- Removed deprecated Z

## Testing
- Added unit tests for X
- Updated integration tests for Y

## Notes for Reviewers
<!-- Anything to call out: tradeoffs, known issues, areas of uncertainty -->

## Screenshots (if applicable)
EOF
)"
```

**Title:** Short, imperative mood. Do not prefix with ticket number unless the team convention requires it.

## Examples

### With JIRA Ticket

User says: "create a PR, ticket is DATA-451"

```markdown
## Summary
Adds CSV export for usage metrics and fixes a timezone offset bug in the daily aggregation query.

## Motivation
[DATA-451](https://jira.example.com/browse/DATA-451)

## Changes
- Added CSV export for usage metrics
- Updated metrics dashboard to show export button
- Fixed timezone offset in daily aggregation query

## Testing
- Added unit tests for CSV serialization edge cases
- Updated dashboard component snapshot tests

## Notes for Reviewers
<!-- Anything to call out: tradeoffs, known issues, areas of uncertainty -->

## Screenshots (if applicable)
```

### Without JIRA Ticket

User says: "open a PR for this branch"

```markdown
## Summary
Adds retry logic to webhook delivery to handle transient failures and prevent message loss.

## Motivation
Webhook deliveries were silently dropping on transient network errors with no retry or visibility.

## Changes
- Added exponential backoff retry for failed webhook deliveries
- Updated webhook status tracking to record retry attempts
- Added dead letter queue for permanently failed webhooks

## Testing
- No test changes

## Notes for Reviewers
<!-- Anything to call out: tradeoffs, known issues, areas of uncertainty -->

## Screenshots (if applicable)
```
