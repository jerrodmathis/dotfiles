# Default rules

When asked to open Google Chrome, follow these instructions:

- personal is Profile 1
- work is Profile 3
- command to open Google Chrome is
  - `open -a "Google Chrome" --args --profile-directory=<profile>`

# Pull Request Guidelines

When asked to create a pull request, if you are in a subdirectory
of `$HOME/code/intellistack/`, follow these rules and use the GitHub MCP
server, if available. The proposed PR should always be shown in markdown
format so I can look over the details before making any tool calls.

## Pull Request Information

- head: the current branch
- base: `main`
- title: <JIRA ticket #>: <brief summary>
- body: <body template below>

The origin will be formstack instead of intellistack.

### JIRA Ticket Information

The JIRA ticket number will typically be the prefix or name NT-#### of the
current branch. The link can be formatted like this:

- [NT-####](https://formstack.atlassian.net/browse/nt-####)

### Body Template

```markdown
# Issue

- <link to JIRA ticket>

# CHANGELOG

- <list changes here>
```

### Best Practices for Changelog Entries

Good examples:

- ✅ "Add validation for user input in the search criteria form"
- ✅ "Implement caching mechanism for frequently accessed dataset queries"
- ✅ "Refactor criteria field operations to use the new async pattern"
- ✅ "Fix race condition in concurrent dataset updates"
- ✅ "Update error handling to provide more descriptive messages"

Bad examples:

- ❌ "Fixed bug" (too vague)
- ❌ "Updated code" (not descriptive)
- ❌ "Made changes to the file" (lacks specificity)
- ❌ "DJ-99" (just referencing the ticket)
- ❌ "Various improvements" (not specific enough)

## Useful Commands

To retrieve the diff between the main branch and the current branch, run:

- `git fetch && git diff origin/main`

To push changes before creating the PR, run:

- `git push`
