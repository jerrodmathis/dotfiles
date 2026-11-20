---
name: full-review
description: Review someone else's PR end to end, from findings to approval. Use when the user asks for a full review of a teammate's PR. Reviewer lane.
disable-model-invocation: true
argument-hint: "[PR#]"
---

# Full Review

You are the reviewer. The PR belongs to someone else. Never commit, push,
rebase, or merge the author's branch. Prototypes for `pr-review` are discarded,
never committed.

Read [pr-review](../pr-review/SKILL.md) for what to hunt, and
[leaving-pr-comments](../leaving-pr-comments/SKILL.md) for comment format.
This skill sets the order and the gates.

## Ledger

Keep a findings ledger for the whole run: id, severity, `path:line`, status,
and thread id once posted. Every later step reads and updates it.

## Steps

1. **Check out the PR.** If the thread is not already in the PR's worktree, use
   the `worktrunk` skill: `wt switch pr:<N>`. `$ARGUMENTS` is the PR number.
2. **Review.** Run `pr-review`. Suggest `council` when the diff touches public
   contracts, CI, or infra, or is large. Suggest it, don't start it unasked.
   If the user asks for it, use the default members from `council`.
3. **Verify.** Every `[Unverified]` or `[Inference]` finding gets checked by
   grep, docs, or a run. If it cannot be verified, drop it or turn it into a
   question for the author. No shallow verification: a false positive costs
   more than a missed nit.
4. **Triage.** Present the findings numbered, then stop. The user answers by
   number ("1-4 real, 5-9 nits, drop 8") and may add context that lowers
   severity ("internal-only flag"). Update the ledger. Do not draft yet.
5. **Draft.** Use `ghostwrite` for the comments. It shows the drafts.
6. **Approval gate.** Ask with `AskUserQuestion`. Options: post as COMMENT,
   post as REQUEST_CHANGES (recommended when there are blockers), revise
   drafts. Post nothing before the answer.
7. **Post** one review. Inline comments only, no review body, each location
   its own comment, nits prefixed `nit:`. Verify the returned URL. Record the
   thread ids and `reviewed_sha` (the head you reviewed) in the ledger.
8. **Wait.** Follow only the "Waiting" section of `babysit-pr`. Call
   `watch_pull_request`, then end your turn. Do not fix or merge anything.
9. **On wake,** run `review-followup` with the ledger.

## Stop rules

- **Approve** with no body only when every finding is verified fixed and no
  author reply disputes one. `review-followup` does the approving.
- **Reply without a fix, or a dispute:** call `unwatch_pull_request` and show
  the user the reply. They decide the follow-up. Do not answer it yourself.
- **Never approve on a wake that only has new comments.**
- **Unwatch when you hand off,** including before any question to the user.
