# .dotfiles

Cross-platform dotfiles managed by [chezmoi](https://www.chezmoi.io/). One repo for personal and work machines -- a single `work` boolean gates everything.

## Quick Start

```bash
# Fresh machine (macOS/Linux) — clones the public mirror:
git clone https://github.com/jaredtconnor/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./install.sh

# Windows (PowerShell as admin):
git clone https://github.com/jaredtconnor/.dotfiles.git $HOME\.dotfiles
cd $HOME\.dotfiles; .\install.ps1
```

The bootstrap script handles everything: installs chezmoi, removes any conflicting Dotbot symlinks from a previous setup, clones the repo to `~/.dotfiles`, and runs `chezmoi init --apply`.

On first run, chezmoi prompts for `work = true/false`; on the work host it auto-detects by hostname. Infrastructure hosts can use the server profile with `CHEZMOI_SERVER=1`. The maintainer's canonical source is a private Forgejo repo; set `DOTFILES_REPO_URL` to override the clone source.

## What's Managed

| Category | Contents |
|---|---|
| **Shell** | Zsh (rc, profile, env), Bash, Fish, PowerShell, Starship prompt |
| **Shell config** | Aliases (6), path augmenters (6), functions (8 sourced + 7 executable) |
| **Editors** | Neovim, VS Code (macOS), Zed |
| **Terminals** | Alacritty, Wezterm, Kitty, Ghostty |
| **Tools** | Git (templated), tmux, sesh, gitmux, mise, prettier |
| **macOS** | Hammerspoon, Sketchybar, Aerospace, Espanso, IINA, Raycast |
| **AI tooling** | Claude Code (settings, commands, hooks), Cursor rules, ccstatusline, OMP global instructions (`~/.omp/agent/AGENTS.md`) |
| **SSH** | Templated config with GitHub identity switching + homelab hosts |
| **Secrets** | `.env` with zero-valued exports (1Password integration planned) |

## How It Works

### Bootstrap Flow

```
install.sh / install.ps1
  ├── Detect OS (macOS / Linux / Windows)
  ├── Install prerequisites (Homebrew / apt / winget)
  ├── Install chezmoi
  ├── Detect & remove old Dotbot symlinks (if migrating)
  ├── Clone repo to ~/.dotfiles
  └── chezmoi init --apply --source ~/.dotfiles
        ├── run_once: Brewfile (macOS) / Linux packages
        ├── run_once: mise install
        ├── Externals: oh-my-zsh, zgenom, tmux plugins, agent tooling repos
        ├── Templates: git config, SSH, .env, chezmoi.toml
        ├── Managed files: shell, editors, terminals, tools
        └── run_after: AI tooling projection symlinks
```

### Hostname-Gated Identity

`~/.config/chezmoi/chezmoi.toml` is written once at `chezmoi init` time:

```toml
[chezmoi]
    sourceDir = "/Users/you/.dotfiles/home"

[data]
    work = false   # set to true on work machines
```

Templates use `.work` to switch git identity, SSH keys, secrets, and which external repos to pull.

### Server Profile

Use the server profile for infrastructure hosts such as Proxmox and storage boxes. It is intentionally minimal: SSH aliases and Git config only. It skips shell frameworks, editor configs, desktop app configs, AI agent runtimes, external tooling repos, and post-apply automation.

`pioneer`, `pve`, and `skylab` auto-detect as server hosts. You can also force the profile during bootstrap:

```bash
CHEZMOI_SERVER=1 chezmoi init --apply --source ~/.dotfiles
```

Headless servers should not rely on 1Password SSH agent keys. Put host-local Forgejo deploy/service keys in `~/.ssh/config.local.d/*.conf`, for example:

```sshconfig
Host git.example.com
    HostName git.example.com
    User git
    Port 222
    IdentityAgent none
    IdentityFile ~/.ssh/forgejo-deploy
    IdentitiesOnly yes
```

### Source Layout

```
.chezmoiroot -> home/
install.sh                              # cross-platform bootstrap (macOS/Linux)
install.ps1                             # Windows PowerShell bootstrap
home/
  .chezmoi.toml.tmpl                    # generates chezmoi config on init
  .chezmoiexternal.toml.tmpl            # git clones replacing old submodules
  .chezmoiignore                        # OS-gated paths (macOS/Windows/Linux)
  .chezmoiscripts/                      # one-shot + post-apply scripts
  .chezmoiscripts/run_after_create-env-from-1password.sh.tmpl  # creates ~/.env once
  private_dot_ssh/config.tmpl           # -> ~/.ssh/config (0600 perms)
  dot_config/git/config.tmpl            # -> ~/.config/git/config
  dot_zshrc                             # -> ~/.zshrc
  dot_config/zsh/                       # aliases/, paths/, functions/
  dot_config/nvim/                      # neovim config
  dot_claude/                           # claude commands, hooks, settings
  dot_cursor/rules/                     # cursor AI rules
  Library/                              # macOS app configs (espanso, IINA, VS Code)
  ...
```

Chezmoi naming conventions: `dot_` = `.`, `private_` = `0600`, `executable_` = `+x`, `.tmpl` = template.

### Externals (Replaces Submodules)

Defined in `.chezmoiexternal.toml.tmpl`. Auto-refreshed weekly on `chezmoi apply`:

| External | Target |
|---|---|
| oh-my-zsh | `~/.oh-my-zsh` |
| zgenom | `~/.zgenom` |
| tmux-sensible, tmux-resurrect, tmux-continuum, tmux-fzf-url, vim-tmux-navigator | `~/.tmux/plugins/` |
| NvChad starter | `~/.config/nvchad-nvim` |
| pi-agent-setup.git | `~/.pi/agent` |
| agent-tooling.git | `~/.agent-tooling` |
| skills-work.git | `~/.skills-work` |

Force-refresh: `chezmoi apply --refresh-externals`

### AI Tooling Split

Reusable AI tooling lives in `agent-tooling.git`, pulled via chezmoi into `~/.agent-tooling`. Work overlays live in the separate `~/.skills-work` repo. A post-apply script (`run_after_symlink-ai-mirror.sh`) flat-symlinks skills, agents, commands, and hooks into Claude, Cursor, Codex, and `.agents` runtime paths.

Machine-specific AI settings and ccstatusline config live directly in this repo under `home/dot_claude/` and `home/dot_config/ccstatusline/`.

## Common Commands

All commands work from any directory.

```bash
chezmoi diff                     # preview changes before applying
chezmoi apply                    # apply all changes to home directory
chezmoi apply -v                 # apply with verbose output
chezmoi add ~/.config/foo/bar    # bring a new file under management
chezmoi add --template ~/.foo    # add as a template
chezmoi edit ~/.zshrc            # edit managed file (applies on save)
chezmoi cat ~/.ssh/config        # show rendered template output
chezmoi managed                  # list all managed files
chezmoi update                   # git pull + apply in one shot
chezmoi apply --refresh-externals  # force-refresh all external repos
chezmoi doctor                   # check for problems
chezmoi data                     # show all template variables
chezmoi cd                       # cd into the source directory
```

### Git Operations

```bash
chezmoi git status
chezmoi git add .
chezmoi git commit -m "update zshrc"
chezmoi git push

# or work in the source directory directly
cd ~/.dotfiles
```

## Machine Profiles

Profiles are selected per machine (see `.chezmoi.toml.tmpl`). Hostnames and the
full inventory live in the private companion, not here.

| Profile | `work` | Notes |
|---|---|---|
| Personal workstation (macOS) | `false` | Primary + mobile dev machines |
| Server / Proxmox / storage | `false` | Minimal server profile (`CHEZMOI_SERVER=1`) |
| Work laptop | `true` | Gets work AI tooling overlay |
| Linux VMs | `false` | Dev / homelab |
| Windows | `false` | Git Bash surface |

## Design Decisions

1. **Hostname gating, with one exception.** Identity is keyed on machine, not repo location. The single `includeIf gitdir:` block covers `~/.dotfiles` itself, which always pushes as the personal email on every machine including work. See `dot_config/git/config.personal`.
2. **Reusable tooling plus work overlay.** `agent-tooling.git` is installed everywhere, with a work-only overlay repo on work machines. This keeps public/personal assets separate from work-internal content.
3. **VS Code as difftool/mergetool.** Git uses `code --wait --diff` and `code --wait --merge`. Delta handles terminal diffs with the Visual Studio Dark+ theme.
4. **Karabiner excluded.** Managed manually outside chezmoi due to its TypeScript build pipeline.
5. **Secrets deferred.** `.env` has zero-valued exports. 1Password `op` reads are a follow-up.
6. **Repo at `~/.dotfiles`.** The chezmoi source dir is `~/.dotfiles/home` (set via `.chezmoi.toml.tmpl`). This keeps the repo at a well-known, easy-to-remember path.

## New Machine Setup

Just SSH access to Forgejo and the bootstrap script. Everything else is automated:

```bash
# Clone, install everything, and apply
git clone https://github.com/jaredtconnor/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./install.sh

# chezmoi will prompt for work = true/false on first init.
# Externals (oh-my-zsh, tmux plugins, agent tooling repos) clone automatically.
# Homebrew installs via run_once script on macOS.
# Linux packages install via run_once script.
# mise installs tool versions via run_once script.
```

Prerequisite repos (already created):
- `pi-agent-setup` -- Pi-specific agent runtime setup (private Forgejo)
- `agent-tooling` -- reusable AI tooling (public: github.com/jaredtconnor/agent-tooling)
- Work AI tooling overlay is managed separately via the work GitHub account

## Migration History

Migrated from a previous dotbot-based setup. The old repo used symlinks and git submodules; this repo uses chezmoi templates and externals. The `install.sh` bootstrap handles the cutover automatically by detecting and removing Dotbot symlinks before applying chezmoi.
