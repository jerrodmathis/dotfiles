---
name: worktrunk
description: >-
  Use Worktrunk (wt) for git worktrees. Apply when creating or switching
  worktrees, starting feature/fix work, or about to edit code while on a
  primary or default-branch worktree. Covers local setup at
  ~/.config/worktrunk/config.toml and ~/code/intellistack.
---

# Worktrunk

Prefer `wt` over raw `git worktree`.

Docs: [worktrunk.dev](https://worktrunk.dev) · [wt switch](https://worktrunk.dev/switch/) · [wt config](https://worktrunk.dev/config/) · [hooks](https://worktrunk.dev/hook/)

## Hard rules

1. **Detect context** before editing:
   - Primary worktree, **or** current branch is the repo default → do **not** edit in place.
   - Already on a feature worktree → continue there.
2. **Create/switch** when rule 1 says leave primary/default:
   ```sh
   wt switch --create <branch>
   ```
   Use `-C <repo-root>` if cwd is wrong. Then continue work in the new worktree path.
3. **Branch name**
   - Use the name from the user/handoff if given.
   - Else `jmathis/<ticket-or-id>` when a ticket/id is known.
   - Else ask — do not invent a branch name.
4. Do not use interactive pickers (`wt switch` with no branch) in agent sessions — always pass an explicit branch.

## Local layout

| What | Where |
|------|--------|
| Working repo primaries | `~/code/intellistack/<repo>` |
| Worktrees (default template) | `~/code/intellistack/<repo>.<branch-sanitized>` |
| Cursor multi-root per repo | `~/.config/cursor/workspaces/<repo>.code-workspace` |

`/` in branch names becomes `-` in the directory name (`sanitize`).

## Local config

User config: `~/.config/worktrunk/config.toml` — **read it** if behavior is unclear.

Notable entries:

| Kind | Name | Behavior |
|------|------|----------|
| alias | `wt s …` | `wt switch …` |
| alias | `wt cursor` | `cursor {{ worktree_path }}` |
| pre-start | `copy-env` | For `odin-ui` only: copy `.env*` from primary into `packages/web-app/` |
| post-start | `install` | `yarn install` if `yarn.lock` exists |
| post-start | `workspace-add` | `workspace-sync add -r {{ repo }} -b {{ branch }} -p {{ worktree_path }}` |
| post-remove | `workspace-remove` | `workspace-sync remove -r {{ repo }} -p {{ worktree_path }}` |

`post-*` hooks run in the background after create/remove. Expect `workspace-sync` to update the Cursor workspace file; do not hand-edit that file for worktree add/remove.

## Common commands

```sh
# Create feature worktree from default branch
wt switch --create <branch>

# Create from an explicit base
wt switch --create <branch> --base <base>

# Switch to existing worktree/branch
wt switch <branch>

# List worktrees
wt list

# Remove current or named worktree
wt remove
wt remove <branch>
```

Do **not** run `wt merge`. Integration is via push + PR, not local squash-merge to the default branch.

After create, if the session must open the worktree in Cursor: `wt cursor` (from that worktree) or `cursor <worktree_path>`.

## Quick check

Before the first edit in a repo session:

```sh
git rev-parse --is-inside-work-tree
git worktree list
git rev-parse --abbrev-ref HEAD
git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || true
```

If HEAD is the default branch and this path is the primary listed by `git worktree list` → `wt switch --create` first.
