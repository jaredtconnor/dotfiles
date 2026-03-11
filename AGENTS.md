# AGENTS.md

## Learned User Preferences

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

## Learned Workspace Facts

- Cross-platform dotfiles repo: macOS, Linux (Fedora), and Windows via Dotbot
- AI skills and agents are shared between Cursor and Claude Code via directory-level symlinks under `tools/ai/`
- `~/.claude` is a real directory managed by Claude Code; symlink individual files INTO it with glob patterns, never replace the directory itself
- Secrets are stored in `env/.secrets.ps1` (gitignored) and auto-loaded by the PowerShell profile
- SSH config uses two GitHub identities: `github-personal` (personal key) and `github.com` (work key `id_ed25519_work`)
- Pre-commit hooks include a local `dotbot-link` hook that runs `dotbot --only link` on every commit
- `install.conf.yaml` is the main Dotbot config; Windows has a separate `install-windows.conf.yaml`
- The `dotbot` submodule must be initialized before running install; other submodules are optional per platform
