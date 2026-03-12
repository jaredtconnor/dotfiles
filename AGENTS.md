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

<!-- BEGIN BEADS INTEGRATION -->
## Issue Tracking with bd (beads)

**IMPORTANT**: This project uses **bd (beads)** for ALL issue tracking. Do NOT use markdown TODOs, task lists, or other tracking methods.

### Why bd?

- Dependency-aware: Track blockers and relationships between issues
- Git-friendly: Dolt-powered version control with native sync
- Agent-optimized: JSON output, ready work detection, discovered-from links
- Prevents duplicate tracking systems and confusion

### Quick Start

**Check for ready work:**

```bash
bd ready --json
```

**Create new issues:**

```bash
bd create "Issue title" --description="Detailed context" -t bug|feature|task -p 0-4 --json
bd create "Issue title" --description="What this issue is about" -p 1 --deps discovered-from:bd-123 --json
```

**Claim and update:**

```bash
bd update <id> --claim --json
bd update bd-42 --priority 1 --json
```

**Complete work:**

```bash
bd close bd-42 --reason "Completed" --json
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
   - `bd create "Found bug" --description="Details about what was found" -p 1 --deps discovered-from:<parent-id>`
5. **Complete**: `bd close <id> --reason "Done"`

### Auto-Sync

bd automatically syncs via Dolt:

- Each write auto-commits to Dolt history
- Use `bd dolt push`/`bd dolt pull` for remote sync
- No manual export/import needed!

### Important Rules

- ✅ Use bd for ALL task tracking
- ✅ Always use `--json` flag for programmatic use
- ✅ Link discovered work with `discovered-from` dependencies
- ✅ Check `bd ready` before asking "what should I work on?"
- ❌ Do NOT create markdown TODO lists
- ❌ Do NOT use external issue trackers
- ❌ Do NOT duplicate tracking systems

For more details, see README.md and docs/QUICKSTART.md.

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd dolt push
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds

<!-- END BEADS INTEGRATION -->
