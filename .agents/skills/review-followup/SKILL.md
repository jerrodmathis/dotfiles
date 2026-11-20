---
name: review-followup
description: Use when the user asks whether the author of someone else's PR addressed their review feedback, or says "the author has addressed the feedback". Reviewer lane.
argument-hint: "[PR#]"
---

# Review Followup

Re-check a PR the user already reviewed. Resolve what is fixed, approve only
when all of it is.

## Ledger

Use the findings ledger from this thread if there is one (see `full-review`).
Otherwise build it from the user's own unresolved review threads. Get the
user's login with `gh api user -q .login`, then query GraphQL
`reviewThreads` on the PR and keep threads whose first comment is theirs.

## Steps

1. **Base.** `reviewed_sha` from the ledger, else the `commit_id` of the
   user's last review on the PR.
2. **Pull.** `git pull --ff-only` in the PR's worktree. Never rebase or push.
3. **Read** `git diff <base>..HEAD` and every author reply since the review.
4. **Judge each finding** from the code, not the reply:
   - fixed
   - partial
   - not fixed
   - disputed
   - replied without a fix

   Cite `path:line` evidence for each verdict.
5. **Check the new code.** New code can add new problems. Run `pr-review`'s
   hunt table over what changed since the base.
6. **Resolve** fixed threads with `resolveReviewThread`, with no comment. Never
   resolve a thread you only believe is fixed.
7. **Approve** with no body only when every finding is fixed and no reply
   disputes one.
8. **Otherwise report and stop.** Show the verdict table. For any reply left
   without a fix, show the reply so the user can decide the follow-up. Do not
   respond to the author.

In T3 Code, call `unwatch_pull_request` before reporting a stop or asking a
question.
