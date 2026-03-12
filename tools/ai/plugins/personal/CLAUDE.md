# Personal Plugin

Personal development workflow tools for Claude Code and Cursor.

## Structure

- `commands/` — Entry points invoked via `/command-name`. Orchestrate skills.
- `skills/` — Reusable workflow units invoked via `Skill()` tool.
- `agents/` — Specialized subagents by category: core, orchestration, languages, specialists.
- `hooks/` — Shell hooks triggered by Claude Code events (defined in hooks.json).

## Conventions

- Skills use SKILL.md with frontmatter: name, description, version
- Agents use .md with frontmatter: name, description, tools, model (optional)
- Commands use .md with frontmatter: description
- Complex skills store supporting docs in `references/` subdirectory
- All hooks use `${CLAUDE_PLUGIN_ROOT}` for paths

## Orchestration Pipeline

```
/orchestration-setup → .orchestration/config.yaml → /run-orchestration
```

The YAML-based orchestration decomposes work into slices with dependencies,
then executes slice-by-slice with quality gates.
