# Dotfiles

Personal cross-platform dotfiles repo. Uses [Dotbot](https://github.com/anishathalye/dotbot) for symlink management. Supports macOS, Linux (Fedora), and Windows.

## Quick Reference

```
just install     # Full install (auto-detects OS)
just link        # Symlinks only (no package installs)
```

## User Preferences

- Use `Jared Connor <jaredconnor@fastmail.com>` as the git author for this repo (not the gmail or work email)
- Use the `github-personal` SSH host alias when pushing to this repo's remote (maps to personal SSH key `~/.ssh/id_rsa`)
- Prefer `linctl` CLI over the Linear MCP server for Linear integration (faster)
- Use conventional commits: `feat`, `fix`, `chore`, `docs`, `refactor`, `ci`, `test`, `style`, `perf`, `build`
- Prefer flat directory names without numbered prefixes (e.g., `core/` not `01-core/`)
- Use `just` as the task runner (not `make`)
- On Windows, the shell is PowerShell with Oh My Posh for prompt theming
- When committing from PowerShell, write the message to a temp file and use `git commit -F` (heredoc and `&&` chaining do not work)
- Do not initialize tmux or zsh submodules on Windows (irrelevant)
- Exclude VS Code/Cursor JSONC files (keybindings, settings) from strict JSON validation hooks

## Workspace Facts

- `~/.claude` is a real directory managed by Claude Code; symlink individual files INTO it with glob patterns, never replace the directory itself
- Secrets are stored in `env/.secrets.ps1` (gitignored) and auto-loaded by the PowerShell profile
- SSH config uses two GitHub identities: `github-personal` (personal key) and `github.com` (work key `id_ed25519_work`)
- Pre-commit hooks include a local `dotbot-link` hook that runs `dotbot --only link` on every commit
- `install.conf.yaml` is the main Dotbot config; Windows has a separate `install-windows.conf.yaml`
- The `dotbot` submodule must be initialized before running install; other submodules are optional per platform
- Global git `commit-msg` hook at `tools/git/githooks/commit-msg` auto-strips AI co-author trailers
- AI skills, agents, commands, and hooks live in `tools/ai/` and are symlinked into `~/.claude/` and `~/.cursor/` via Dotbot

## Directory Layout

```
editor/          Neovim, LazyVim, LunarVim, VS Code, Cursor, Zed configs
env/             Secrets (.secrets, .secrets.ps1) - not committed
languages/       Node/Prettier configs
machines/        OS-specific setup (osx/Brewfile, fedora/fedora_setup.sh)
shell/
  aliases/       Shell aliases by category (git, node, vim, tools, zsh, fedora)
  bash/          .bashrc, .bash_profile
  fish/          Fish shell config
  functions/     fzf helpers, git functions, nvim switcher -> symlinked to ~/bin
  powershell/    PowerShell profile + Oh-My-Posh theme (Windows)
  scripts/       Standalone scripts (dev-setup, github-ssh-setup)
  zsh/           .zshrc, oh-my-zsh (submodule), zgenom (submodule)
terminal/        Alacritty, Wezterm, Kitty, Ghostty configs
tmux-plugins/    Tmux plugin submodules (resurrect, continuum, fzf-url, sensible, vim-tmux-navigator)
tools/
  ai/            AI tooling shared between Cursor and Claude Code (see below)
  aerospace/     Tiling WM (macOS)
  espanso/       Text expansion (macOS)
  git/           .gitconfig, .gitconfig-work, .gitconfig-personal, set-gitconfig.sh, githooks/
  hammerspoon/   macOS automation
  karabiner/     Keyboard remapping (macOS) - TypeScript config compiled with Deno
  mise/          Runtime version manager (go, node, python, deno, bun, direnv, rust)
  sketchybar/    Status bar (macOS)
  tmux/          .tmux.conf, setup-tmux.sh
```

## Dotbot (install.conf.yaml)

All symlinks and setup steps are defined in `install.conf.yaml`. The file uses YAML list format with `defaults`, `clean`, `shell`, and `link` sections.

### Platform Detection

| Condition | Platform |
|-----------|----------|
| `if: "[ \`uname\` = Darwin ]"` | macOS |
| `if: "[[ \`uname\` = Linux ]]"` | Linux |
| `if: "ver"` | Windows |
| `if: "python3 -c \"import sys;exit(sys.platform=='win32')\""` | Unix (not Windows) |

### Adding a New Symlink

Add entries to the `- link:` section. Dotbot defaults: `relink: true`, `create: true`.

```yaml
~/.config/tool/config.toml:
  path: ./tools/tool/config.toml
  force: true

~/.config/tool/:          # Trailing slash + glob = link each matched item inside target dir
  path: ./tools/tool/*
  glob: true
  force: true
```

Platform-conditional example:
```yaml
~/.config/tool:
  if: "[ `uname` = Darwin ]"
  path: ./tools/tool
  force: true
```

## AI Tooling (tools/ai/)

Skills, agents, commands, and hooks are **shared between Cursor and Claude Code** via directory-level symlinks managed by Dotbot. Both `~/.cursor/skills` and `~/.claude/skills` point to `tools/ai/skills/`. Same for agents.

```
tools/ai/
  skills/        Shared skills (SKILL.md format) -> ~/.cursor/skills AND ~/.claude/skills
  agents/        Shared agents (.md with YAML frontmatter) -> ~/.cursor/agents AND ~/.claude/agents
  commands/      Entry points invoked via /command-name -> ~/.claude/commands
  hooks/         Shell hooks triggered by Claude Code events (registered in .claude/settings.local.json)
  claude/        Claude Code-specific: settings.json
  cursor/        Cursor-specific: rules/ (.mdc files)
```

### Creating a New Skill

Create `tools/ai/skills/<skill-name>/SKILL.md` with YAML frontmatter. It appears in both tools immediately.

```yaml
---
name: skill-name
description: When to use this skill. Be specific for auto-invocation.
---
# Skill Title

Instructions here...
```

### Creating a New Agent

Create `tools/ai/agents/<category>/<agent-name>.md`. Agent categories: core, orchestration, languages, specialists.

```yaml
---
name: agent-name
description: What this agent does and when to use it
model: sonnet
---
System prompt here...
```

### Claude Code Hooks

Defined in `.claude/settings.local.json` under the `hooks` key. Hook scripts live in `tools/ai/hooks/`. Active hooks:
- `tech-lead-check.sh` - runs on prompt submit and before tool use
- `enforce-best-practices.sh` - runs after file writes
- `memory-sync.sh` - runs after file writes
- `compound-engineering.sh` - runs after file writes and task dispatches

## Submodules

| Submodule | Path |
|-----------|------|
| dotbot | `dotbot/` |
| dotbot-asdf | `dotbot-plugins/dotbot-asdf` |
| oh-my-zsh | `shell/zsh/oh-my-zsh` |
| zgenom | `shell/zsh/zgenom` |
| tmux-sensible | `tmux-plugins/tmux-sensible` |
| tmux-resurrect | `tmux-plugins/tmux-resurrect` |
| tmux-continuum | `tmux-plugins/tmux-continuum` |
| tmux-fzf-url | `tmux-plugins/tmux-fzf-url` |
| vim-tmux-navigator | `tmux-plugins/vim-tmux-navigator` |

## Conventions

- Shell scripts use `#!/usr/bin/env bash` and `set -e`
- Task runner is `just` (not make) - justfile at repo root
- Runtime versions managed by mise (`tools/mise/config.toml`)
- macOS packages tracked in `machines/osx/Brewfile`
- Editor configs go in `editor/<editor-name>/`
- Tool configs go in `tools/<tool-name>/`
- All symlinks defined in `install.conf.yaml` - do not create symlinks manually

## Issue Tracking with bd (beads)

This project uses **bd (beads)** for ALL issue tracking. Do NOT use markdown TODOs, task lists, or other tracking methods.

### Quick Start

```bash
bd ready --json              # Check for ready work
bd create "Title" --description="Context" -t bug|feature|task -p 0-4 --json
bd update <id> --claim --json
bd close <id> --reason "Done" --json
```

### Issue Types

- `bug` - Something broken
- `feature` - New functionality
- `task` - Work item (tests, docs, refactoring)
- `epic` - Large feature with subtasks
- `chore` - Maintenance (dependencies, tooling)

### Priorities

- `0` - Critical (security, data loss, broken builds)
- `1` - High (major features, important bugs)
- `2` - Medium (default, nice-to-have)
- `3` - Low (polish, optimization)
- `4` - Backlog (future ideas)

### Workflow for AI Agents

1. **Check ready work**: `bd ready` shows unblocked issues
2. **Claim your task atomically**: `bd update <id> --claim`
3. **Work on it**: Implement, test, document
4. **Discover new work?** Create linked issue:
   - `bd create "Found bug" --description="Details" -p 1 --deps discovered-from:<parent-id>`
5. **Complete**: `bd close <id> --reason "Done"`

### Auto-Sync

bd automatically syncs via Dolt. Use `bd dolt push`/`bd dolt pull` for remote sync.

### Rules

- Use bd for ALL task tracking
- Always use `--json` flag for programmatic use
- Link discovered work with `discovered-from` dependencies
- Check `bd ready` before asking "what should I work on?"
- Do NOT create markdown TODO lists or use external issue trackers

## Session Completion

When ending a work session, complete ALL steps below. Work is NOT complete until `git push` succeeds.

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE**:
   ```bash
   git pull --rebase
   bd sync
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

Work is NOT complete until `git push` succeeds. Never stop before pushing. Never say "ready to push when you are" -- YOU must push. If push fails, resolve and retry until it succeeds.
