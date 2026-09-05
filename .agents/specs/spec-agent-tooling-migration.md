# Specification: Agent Tooling Repository Migration

## Overview

Migrate the current AI tooling source from a misleading `~/.skills` identity to a canonical `~/.agent-tooling` repository. The migration should preserve existing history, keep current agent runtime paths working, and clarify ownership boundaries between reusable AI tooling and machine bootstrap configuration.

The desired outcome is a cleaner source-of-truth model: `~/.agent-tooling` owns reusable AI assets, while `~/.dotfiles` owns installation, machine-specific configuration, external cloning, and projection wiring.

## User Stories

- As the owner of the dotfiles setup, I want reusable AI tooling to live in `~/.agent-tooling` so the repository name matches the content it owns.
- As a user of Claude Code, Cursor, Codex, and related tools, I want existing runtime paths to keep working so the migration does not interrupt daily agent workflows.
- As a maintainer, I want skills to remain compatible with the open Agent Skills ecosystem so they can be installed, listed, updated, or shared through `npx skills` where appropriate.
- As a maintainer, I want agents, commands, hooks, plugin metadata, tests, scripts, and references managed alongside skills so related AI tooling can evolve together.
- As a repo owner, I want incremental commits and pushes so each migration checkpoint is reviewable and recoverable.

## Expected Behaviors

- When the migration is complete, `~/.agent-tooling` is the canonical local source repo for reusable AI tooling.
- The existing Forgejo `skills.git` repository is renamed or moved to `agent-tooling.git` while preserving git history.
- The `~/.agent-tooling` repo owns all reusable AI tooling, including `skills/`, `agents/`, `commands/`, `hooks/`, `references/`, tests, scripts, plugin metadata, and related documentation.
- Dotfiles continue to own bootstrap behavior, machine-specific configuration, editor settings, Claude/Cursor settings, and the logic that clones or wires the external agent tooling repo.
- Existing projections continue to work, including Claude, Cursor, Codex, and `.agents` compatibility paths already used by local tools.
- Skills projection should align with Vercel/open Agent Skills conventions and support `npx skills` workflows where those workflows apply.
- Non-skill projections remain repo-managed because `npx skills` does not manage agent personas, commands, hooks, or plugin metadata.
- The migration proceeds through coherent checkpoints: specification, source repo rename/move, tooling repo cleanup, projection verification, dotfiles update, and final validation.

## Success Criteria

- [ ] A local specification exists under `.agents/specs/` and `.agents/config.yaml` records the local workflow state.
- [ ] The Forgejo repository is renamed or moved from `skills.git` to `agent-tooling.git` with history preserved.
- [ ] The local source checkout exists at `~/.agent-tooling`.
- [ ] The old `~/.skills` path is no longer treated as the canonical source of truth.
- [ ] All reusable AI tooling currently intended to be reused across tools lives in `~/.agent-tooling`.
- [ ] Existing runtime projections keep working for Claude Code, Cursor, Codex, and `.agents` compatibility consumers.
- [ ] Skills can be discovered or managed through `npx skills` where supported by the CLI.
- [ ] Agents, commands, hooks, and plugin metadata remain available through repo-managed projection logic.
- [ ] `~/.dotfiles` references the renamed `agent-tooling.git` external and no longer describes the source as only a skills repo.
- [ ] Changes are committed and pushed incrementally to the relevant remotes.

## Data Requirements

**Repositories**

- `~/.agent-tooling`: canonical source repo for reusable AI tooling.
- Forgejo `agent-tooling.git`: canonical remote for the source repo, preserving history from the old `skills.git`.
- `~/.dotfiles`: bootstrap and projection management repo.

**Reusable AI tooling content**

- Skills: open Agent Skills-compatible directories containing `SKILL.md`.
- Agents: reusable personas or subagent definitions.
- Commands: user-facing workflow entry points.
- Hooks: runtime automation scripts.
- References: shared reusable guidance.
- Supporting files: tests, scripts, docs, plugin metadata, lock files, and project configuration that support the tooling repo.

**Runtime projections**

- Existing Claude Code, Cursor, Codex, and `.agents` paths must continue to resolve to the appropriate source content.
- Generated or projected runtime paths are not the canonical editing location.

## Edge Cases And Error Conditions

- If the Forgejo repo cannot be renamed directly, create or move to an `agent-tooling.git` remote while preserving history and document any old-URL compatibility behavior.
- If `npx skills` cannot manage a required path, keep that path under repo-owned projection management.
- If a projection path already exists as a real directory with local changes, preserve or inspect it before replacing it with a symlink.
- If work-specific tooling exists, keep private/work assets separate from public reusable tooling unless explicitly intended to be shared.
- If old paths such as `~/.skills` are still referenced by scripts, docs, or commands, update those references or leave a clearly temporary compatibility shim.

## Out Of Scope

- Redesigning individual skills, agents, commands, or hooks.
- Changing the behavior of existing AI workflows beyond path ownership and projection management.
- Replacing all projection logic with `npx skills`; the CLI only covers skills-related workflows.
- Creating separate repos for skills and agents unless a future ownership or visibility boundary requires it.
- Migrating unrelated dotfiles, editor configuration, or shell tooling.
