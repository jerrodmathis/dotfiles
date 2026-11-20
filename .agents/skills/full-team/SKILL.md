---
name: full-team
description: Trigger this if the user says 'full team'. Author lane.
---

# Full Team

Do the same work as `full-stop`, for a company that requires a human teammate
to review and approve every PR. `full-send` and `full-stop` do not model that
gate. Never merge unless the "Merge" override below applies.

Read [full-stop](../full-stop/SKILL.md) and follow it. An explicit "full team"
request authorizes that work without a separate "full stop" request, including
its testing permission. Only the overrides below change it, and they take
precedence.

## Overrides

- **PR creation:** if the repo has its own PR skill (`create-pull-request` in
  odin-ui, `pull-request` in session-kit), use it instead of `file-pr`. It
  carries the repo's template. Open as a draft unless the user said it is
  ready. Ask the template's questions (confidence, how tested, screenshots) in
  one `AskUserQuestion`. Never guess answers about manual testing.
- **Ticket:** the branch and PR reference an `FE-` ticket. If none exists, use
  `file-ticket`.
- **Visual proof:** when the repo has visual baseline tests, update the
  baselines and use them as the PR's screenshots.
- **Before asking humans:** run `sol-loop`, as full-send step 3, so teammates
  review a cleaner diff.
- **Request review:** when the user says the PR is ready, mark it ready and
  draft a Slack review request with `ghostwrite`. Post it to the team channel
  the user names, for example #feat-theme-plumbing or #fe-foundations-team.
  Send only after the user approves the draft.
- **Human feedback:** handle it with `address-feedback`, under this grant. Fix
  feedback that verifies as valid without asking, push, and re-request review
  from that reviewer. For invalid or disputed feedback, draft the reply with
  `ghostwrite` and ask before posting. Bot findings follow `babysit-pr`.
- **Approval:** only a human approval counts. Never approve your own PR. Never
  ask a bot or a delegate to approve it.
- **Merge:** full-stop's no-merge rule stands unless the user's request said to
  merge after approval. Then merge only with required checks green, approval
  on the latest head, and the merge-hold check from `address-feedback` clear.
  After merging, watch the deploy as `address-feedback` says.

## Stop

Once review is requested and only a human reviewer is left, hand back. Keep
watching only if the user asked you to stay through approval. In T3 Code, call
`unwatch_pull_request` first.

Report the state "Waiting for review" with the PR link, the reviewers
requested, and the Slack message link.
