---
name: pull-request
description: Generate pull request descriptions with JIRA ticket linking and structured changelogs. Use when creating a pull request, writing a PR description, or asked to open a PR.
---

# Pull Request

Generate structured PR descriptions with JIRA issue linking and concise changelogs.

## PR Description Format

Every PR description has exactly two sections:

```markdown
# Issue

[PROJ-123](https://JIRA_BASE_URL/browse/PROJ-123)

# CHANGELOG

- Added user authentication endpoint
- Fixed token refresh race condition
- Removed deprecated session handler
```

## Workflow

1. **Use git** for all VCS commands
2. **Gather context** - diff the current branch against base to understand all changes
3. **Determine issue section** - use JIRA ticket if provided, otherwise write short summary
4. **Build changelog** - concise bullet list from the diff
5. **Create PR** - use `gh pr create` or `glab mr create` with the formatted body

## Section Rules

### # Issue

| Scenario | Content |
|----------|---------|
| Ticket number provided (e.g. `PROJ-123`) | `[PROJ-123](https://JIRA_BASE_URL/browse/PROJ-123)` |
| No ticket number | 1-2 sentence summary of the PR's purpose |

**JIRA link format:** `[TICKET-KEY](https://JIRA_BASE_URL/browse/TICKET-KEY)`

If the JIRA base URL is unknown, ask the user once and reuse for the session. If a project's JIRA base URL has been used before in conversation, reuse it.

### # CHANGELOG

- Each bullet starts with a past-tense verb: Added, Fixed, Removed, Updated, Refactored, Replaced
- One bullet per logical change, not per file
- Group related file changes into a single bullet
- No implementation details - describe *what changed* not *how*
- Order: additions first, then modifications, then removals

| Good | Bad |
|------|-----|
| `Added rate limiting to /api/upload` | `Changed upload.ts` |
| `Fixed null pointer in user lookup` | `Added null check on line 42 of user-service.ts` |
| `Removed legacy OAuth1 support` | `Deleted oauth1.ts, oauth1-types.ts, oauth1-utils.ts` |
| `Updated error messages to include request ID` | `Modified error handling` |

## Constructing the Diff

Analyze **all commits** on the branch since divergence from base, not just the latest commit.

```
git log --oneline main..HEAD
git diff main...HEAD
```

## Creating the PR

Use a heredoc to pass the body for correct formatting:

```bash
gh pr create --title "Short descriptive title" --body "$(cat <<'EOF'
# Issue

[PROJ-123](https://jira.example.com/browse/PROJ-123)

# CHANGELOG

- Added new feature X
- Fixed bug in Y
- Removed deprecated Z
EOF
)"
```

**Title:** Short, imperative mood. Do not prefix with ticket number unless the team convention requires it.

## Examples

### With JIRA Ticket

User says: "create a PR, ticket is DATA-451"

```markdown
# Issue

[DATA-451](https://jira.example.com/browse/DATA-451)

# CHANGELOG

- Added CSV export for usage metrics
- Updated metrics dashboard to show export button
- Fixed timezone offset in daily aggregation query
```

### Without JIRA Ticket

User says: "open a PR for this branch"

```markdown
# Issue

Add retry logic to webhook delivery to handle transient failures.

# CHANGELOG

- Added exponential backoff retry for failed webhook deliveries
- Updated webhook status tracking to record retry attempts
- Added dead letter queue for permanently failed webhooks
```
