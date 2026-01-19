---
name: git-worktree
description: Manages git worktrees for feature development. Use when starting new features or switching between parallel work.
allowed-tools: Bash(git:*), Read
---

# Git Worktree Workflow

## When to Use

- Starting a new feature
- Working on multiple features in parallel
- Isolating experimental changes

## How to use

`/git-worktree my-new-feature`

## Process

1. Create worktree: `git worktree add ../<name> -b feature/<name>`
2. cd into worktree directory
3. Create a new tmux window based on that new worktree directory
4. Develop in isolation
5. When done: `git worktree remove ../<name>`

## Best Practices

- Name worktrees descriptively using kebab case
- Keep main worktree clean and on main / master branch
- Remove stale worktrees regularly
