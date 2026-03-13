# Dotfiles

Personal cross-platform dotfiles repo. Uses [Dotbot](https://github.com/anishathalye/dotbot) for symlink management. Supports macOS, Linux (Fedora), and Windows.

## Quick Reference

```
just install     # Full install (auto-detects OS)
just link        # Symlinks only (no package installs)
```

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
  git/           .gitconfig, .gitconfig-work, .gitconfig-personal, set-gitconfig.sh
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

Skills and agents are **shared between Cursor and Claude Code** via directory-level symlinks. Both `~/.cursor/skills` and `~/.claude/skills` point to the same `tools/ai/skills/` directory. Same for agents.

```
tools/ai/
  skills/        Shared skills (SKILL.md format) -> ~/.cursor/skills AND ~/.claude/skills
  agents/        Shared agents (.md with YAML frontmatter) -> ~/.cursor/agents AND ~/.claude/agents
  claude/        Claude Code-specific: settings.json, hooks/, commands/, docs
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

Create `tools/ai/agents/<category>/<agent-name>.md`. Agent categories: core, orchestration, languages, frameworks, architecture, specialists, devops, testing, documentation, data, optimization, learning.

```yaml
---
name: agent-name
description: What this agent does and when to use it
model: sonnet
---
System prompt here...
```

### Claude Code Hooks

Defined in `tools/ai/claude/settings.json` under `hooks`. Active hooks:
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
