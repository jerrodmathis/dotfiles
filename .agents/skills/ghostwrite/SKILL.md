---
name: ghostwrite
description: Use when the user asks Sonnet (or another model) to draft text posted on their behalf: PR comments, review replies, Slack messages, Jira ticket descriptions.
---

# Ghostwrite

A cheaper model drafts, the user approves, then you post. The drafting model
never posts.

## Steps

1. **Brief the drafter.** Spawn `Agent` with `model: "sonnet"` and
   `run_in_background: false`, unless the user named another model. The child
   has no history, so the brief carries everything:
   - artifact type and audience
   - the facts, each with its source (`path:line`, link, quote)
   - constraints from the defaults below
   - "Draft only: do not post, edit, commit or push."
2. **Show every draft** with `send_to_user`. Post nothing before the user
   says so.
3. **Revise** through the same model. Honor requests like "less terse, maximum
   impact with minimal reading".
4. **Post,** then verify the returned URL or message link.

## Defaults per artifact

- **PR comments.** Follow `leaving-pr-comments`, with the attribution naming
  the drafting model as it reports itself. One comment per location. Anchor
  only on lines in the diff. Nits start with `nit:`. No top-level summary
  unless asked. Lead with the conclusion. Readable, not dense.
- **Slack.** Bare bullets, PR title as link text, a few words each. Use the
  link syntax the Slack tool renders, and check the posted message.
- **Jira.** Summary, context, acceptance criteria.
