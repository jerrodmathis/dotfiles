# Skills

Every skill belongs to a lane, keyed on one question: whose branch is it? In the
author lane the branch is mine, so a skill may commit, push, and rebase it. In
the reviewer lane the branch is someone else's, so a skill never writes to it.
Its output is comments, resolved threads, and approvals. Shared skills cover
format, drafting, and infra that both lanes use.

## Author lane

| Skill              | Kind         | Source          |
| ------------------ | ------------ | --------------- |
| `full-send`        | orchestrator | tstack          |
| `full-stop`        | orchestrator | tstack          |
| `full-team`        | orchestrator | mine            |
| `sol-loop`         | step         | tstack          |
| `file-pr`          | step         | tstack          |
| `babysit-pr`       | step         | tstack          |
| `modernize`        | step         | tstack          |
| `takeover`         | step         | tstack          |
| `address-feedback` | step         | mine            |

## Reviewer lane

| Skill             | Kind         | Source |
| ----------------- | ------------ | ------ |
| `full-review`     | orchestrator | mine   |
| `pr-review`       | step         | mine   |
| `review-followup` | step         | mine   |

## Shared

| Skill                  | Kind      | Source          |
| ---------------------- | --------- | --------------- |
| `council`              | step      | tstack          |
| `leaving-pr-comments`  | primitive | tstack          |
| `ghostwrite`           | primitive | mine            |
| `file-ticket`          | step      | mine            |
| `worktrunk`            | primitive | mine            |
| `handoff`              | primitive | other           |
| `grilling`             | step      | other           |
| `grill-me`             | step      | other           |
| `grill-with-docs`      | step      | other           |
| `build-skill`          | step      | other           |
| `playwright-cli`       | primitive | other           |

## Rules

1. tstack skills are starting points. Edit them freely. Upstream lives at
   `~/github.com/t3dotgg/tstack`. Review its changes and merge what fits by hand.
2. Lane-specific skills end their description with their lane ("Author lane."
   or "Reviewer lane."). A description that could match either lane names the
   PR owner too: `babysit-pr` says "a PR they own", reviewer skills say
   "someone else's PR".
3. Orchestrators own permissions and stop points. Steps own how-to.
4. Add a new skill only if I would run it on its own.

## Sync upstream

```bash
cd ~/github.com/t3dotgg/tstack
old=$(git rev-parse HEAD) && git pull -q
git log --oneline "$old"..HEAD -- skills   # what changed upstream
git diff "$old"..HEAD -- skills            # merge what fits into ~/.agents/skills
```
