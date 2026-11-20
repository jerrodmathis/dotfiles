---
name: pr-review
description: Extremely strict maintainability review of the current branch. Hunts for structural simplifications ("code judo"), spaghetti growth, file bloat, leaky abstractions, and muddy type contracts.
disable-model-invocation: true
argument-hint: "[PR# | branch]"
---

# PR Review

Audit the branch's changes for **structure**, not correctness. The goal is to find restructurings that keep behavior identical but make the code dramatically smaller, more direct, and more obvious in hindsight. Don't settle for "a bit cleaner" when a reframing can make whole branches, modes, helpers, or layers disappear. Do not approve just because it works. A short scope check against the Jira ticket rides alongside.

## Setup

Review from a worktree of the author's branch, never from diff hunks alone.

- `$ARGUMENTS` may be a PR number, a branch, or empty (= the branch in the current worktree).
- Not in the author's worktree yet: `wt switch pr:<N>` (or `wt switch <branch>`), then work from that path.
- Already in it: `git fetch && git status -sb`. If behind upstream, `git pull --ff-only`. Don't review stale code.
- Working tree must be clean (`git status --porcelain` empty). Otherwise your own leftovers end up in the diff.
- Base = the PR's real target, not an assumed `main`:
  `base_ref=$(gh pr view --json baseRefName -q .baseRefName 2>/dev/null || echo main)`
  `base=$(git merge-base HEAD "origin/$base_ref")`
- Read `CLAUDE.md` / `AGENTS.md` / `CONTRIBUTING.md` (repo root + nearest to changed files) before judging anything.
- Read every changed file **in full** plus its direct callers/callees.
- Review what the diff introduces or worsens. Pre-existing mess is in scope only if the diff grows it, or the diff makes a judo move newly obvious.

## Scope vs ticket

1. Get the ticket key (`<PROJECT>-<number>`; usually `FE-`, sometimes `NT-`, accept any prefix) from the branch name, else the PR title:
   ```bash
   { git branch --show-current; gh pr view --json title -q .title 2>/dev/null; } \
     | grep -oiE '[a-z]{2,}-[0-9]+' | head -1 | tr '[:lower:]' '[:upper:]'
   ```
2. Fetch it with the Atlassian MCP (`getJiraIssue`): summary, description, acceptance criteria. If it doesn't resolve, the match was a false positive; treat as no ticket.
3. Report, quoting the ticket line for each finding:
   - asked for, but missing or partial
   - changed, but not asked for (scope creep)
4. No ticket → write "no ticket found" in the output and continue. Never block on this.

## Validate judo moves (optional, recommended for blockers)

The worktree lets you prove a restructure keeps behavior the same instead of asserting it:

1. Run the project's typecheck/tests once for a baseline (wait for the `install` hook to finish first).
2. Prototype the restructure, re-run, and note the result in the finding.
3. Discard with `git checkout . && git clean -fd`. Never commit or push to the author's branch.

## Mechanical checks (run them, don't eyeball)

```bash
base_ref=$(gh pr view --json baseRefName -q .baseRefName 2>/dev/null || echo main)
base=$(git merge-base HEAD "origin/$base_ref")
git diff --name-only --diff-filter=AM "$base" | while read -r f; do
  before=$(git show "$base:$f" 2>/dev/null | wc -l | tr -d ' ')
  after=$(wc -l < "$f" | tr -d ' ')
  [ "$before" -le 1000 ] && [ "$after" -gt 1000 ] && echo "CROSSED 1K: $f ($before -> $after)"
done
```

## What to hunt for

| Smell | Push for |
| --- | --- |
| Complexity rearranged/centralized but not deleted | Reframe the state model or ownership so the branches vanish |
| New `if`s, flags, nullable modes bolted onto an unrelated or already-busy flow | Dedicated abstraction, typed model, dispatcher, or separate module |
| "Temporary" special-casing | Simpler default flow with fewer exceptions |
| File pushed from <1000 to >1000 lines | Decompose first; waive only with a stated structural reason |
| Feature logic in shared code; logic in the wrong layer/package | Move it to the layer that already owns the concept |
| Bespoke helper duplicating an existing one | Reuse the canonical one (cite its path) |
| Copy-pasted logic | Extract a helper / collapse into one flow |
| Thin wrapper, identity abstraction, pass-through helper | Delete it; keep the direct flow |
| Generic "magic" hiding a simple data shape | Direct, boring code |
| `any` / `unknown` / casts / needless optionality / silent fallbacks | Explicit typed contract at the boundary |
| Independent async work serialized; related updates that can half-apply | Parallel / atomic flow, only when that also simplifies |
| Same `switch`/`if`-cascade on one type recurring across the diff | One shared map or polymorphism |
| Same few params/fields always travelling together | Bundle them into one type |
| One logical change scattered across many files (shotgun surgery) | Gather what changes together into one module |
| Abstraction/params/hooks for needs nobody has (speculative generality) | Delete it; inline until a real need shows |

## Guardrails

Ambition without discipline turns into architecture astronautics. Every proposed restructure must:

- **Preserve behavior.** Name any edge case that could shift.
- **Reduce net concepts.** Fewer types/branches/files/flags a reader must hold, not just different ones.
- **Be proportional.** A 20-line PR doesn't earn a repo-wide rewrite; list that as a follow-up.
- **Be concrete.** Show the sketch (signatures, before/after snippet), not "consider refactoring".
- **Be verified.** Only claim a helper/pattern "already exists" after grepping and finding it.
- **Verify before surfacing.** No finding labeled `[Unverified]` or `[Inference]` reaches the output. Verify it by grep, docs, or running it. If that fails, move it to a "Questions for the author" list.
- **Respect repo rules.** Don't flag patterns the repo's docs endorse. Skip anything lint/prettier/tsc already enforces.

Skip naming/formatting nits unless there's nothing structural to say.

## Verdict

**Blockers** (unless the author justifies them):

- a visible code-judo move left on the table
- a file pushed past 1k lines
- ad-hoc branching that tangles an existing flow / feature checks scattered through shared code
- an unnecessary wrapper or cast-heavy contract that makes the design more indirect
- a duplicated canonical helper or logic in the wrong layer

Everything else from the hunt table is a judgement call: label it as one ("possible shotgun surgery") and file it under Should fix, not Blockers.

## Output

```md
## Verdict: BLOCK | CHANGES REQUESTED | APPROVE

### Blockers

1. **<title>** — `path:line`
   Problem: <1–2 sentences on why it hurts maintainability>
   Judo move: <the restructure, with a code sketch>

### Should fix

...

### Follow-ups (out of scope for this PR)

...

### Scope vs [<KEY>](https://formstack.atlassian.net/browse/<KEY>)

- Missing/partial: <requirement> — "<quoted ticket line>"
- Not asked for: <change> — `path:line`
```

Rank by impact. Aim for ≤ ~8 findings; a few high-conviction comments beat a long cosmetic list.

## Tone

Direct and demanding, not rude. Don't soften structural problems into mild suggestions. Lowercase reviewer voice:

- `this adds another special case to an already busy flow. can we move it behind its own abstraction?`
- `this moves complexity around but doesn't delete it. is there a simpler model where these branches disappear?`
- `this pushes the file past 1k lines. can we decompose first?`
- `why does this need a cast / optional here? can we make the boundary explicit instead?`
