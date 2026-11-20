---
name: address-feedback
description: Use when the user wants review feedback on their own PR checked and handled. Author lane.
argument-hint: "[PR#]"
---

# Address Feedback

For the user's own PR. Report first, change nothing until they pick.

## Step 1: Report only

Pull every unresolved comment and review newer than the last push. Verify each
claim against the code, the docs, or a run. Give each a verdict: valid, partly
valid, or invalid, with evidence.

No `[Inference]` in the report. Verify it, or write "could not verify".
Certainty over speed.

Present the report numbered, then stop and wait for the user to pick.

## Step 2: Act on the picks

- **Valid items:** start an `Agent` with the Opus model to implement them.
- **Declined items:** draft replies with `ghostwrite`. Skip replies to Aikido
  findings unless the user asks.
- Run the repo's checks, push, then resolve only threads that were answered or
  fixed. Re-request review from whoever left the feedback.

## Step 3: Wait

Hand off to `babysit-pr` for waiting and CI. Merge only when the user asked.

## Merging

For `odin-ui`, before any merge, read today's messages in
#streamline-qa and #streamline-odin-development. A hold request with no
all-clear after it means do not merge: call `unwatch_pull_request` and report.

After a merge the user asked for, watch the "CD - Deploy UI" run and report
any failure.

Use `AskUserQuestion` when you need the user. Follow `full-send`'s rules for
asking.
