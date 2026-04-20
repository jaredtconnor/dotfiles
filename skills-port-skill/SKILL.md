---
name: port-skill
description: Safely copy or move a skill between the personal and work skills repos with a scrub/review gate to prevent leaking work-internal content. Use when a skill written in one repo should also exist in the other.
---
# port-skill

Moves or copies one skill between `skills-personal` and `skills-work`, pausing for a human review that the content is safe to cross the boundary.

## When to invoke

- Built a skill in `skills-work` that is generic enough for `skills-personal`.
- Built a skill in `skills-personal` and want it on the work machine too.
- Want to duplicate (not move) so both repos carry their own copy.

## Inputs

- `skill_name`: directory name inside `skills/` (e.g. `bug-investigation`)
- `direction`: `personal-to-work` or `work-to-personal`
- `mode`: `copy` (default) or `move`

## Repo paths

Both are staged by chezmoi-external:

- Personal: `~/.local/share/chezmoi-skills-personal`
- Work: `~/.local/share/chezmoi-skills-work`

The flat-linker at `~/.claude/skills/<skill>` points into one of these staging paths.

## Procedure

1. **Verify source skill exists.** Abort with a clear error if not.
2. **Dump the skill.** Read `SKILL.md` plus every file in the skill directory.
3. **Scrub scan.** Flag any line matching the sensitivity list:
   - Strict denylist (abort if hit, require manual scrub):
     - `BEGIN .* PRIVATE KEY`, `api[_-]?key\s*=`, `token\s*=`, `secret\s*=`, `password\s*=` with a non-empty value
   - Work-sensitive terms (show to user, require ack):
     - `empyrean`, `empyreansolutions`, company product names, internal hostnames, ticket prefixes
   - Personal-only terms (only matter `personal-to-work`):
     - homelab hostnames, personal domain names, personal email, personal tokens
4. **Present findings.** Show file + line ranges for every match. Ask user to proceed, edit-and-proceed, or abort.
5. **Copy to target repo.** Preserve directory structure inside the target's `skills/<skill_name>/`.
6. **Commit in target repo.** Message: `port: add <skill_name> from <source_repo>`. The commit-msg hook strips AI trailers; no need to add them.
7. **If mode=move:** delete from source, commit `port: remove <skill_name> (moved to <target_repo>)`.
8. **Confirm before push.** Show diff summary; ask before `git push` on either repo.
9. **Re-trigger chezmoi.** Run `chezmoi apply` to re-run the mirror symlinker so the skill appears under `~/.claude/skills` and `~/.cursor/skills` immediately.

## Non-negotiables

- Scrub findings are always surfaced to the human, even when empty ("no matches found — proceed?").
- Strict denylist hits abort automatically.
- Default `mode` is `copy`. Never silently move.
- Never push without explicit confirmation.
- Never add AI co-author trailers to commits in either repo.

## Failure modes to catch

- Skill has symlinks into paths outside `skills/<skill_name>/`. Refuse — porting a broken link silently is worse than failing.
- Target repo already has a skill with the same name. Stop and ask: overwrite, rename, or abort?
- Source skill name is present in both repos already (pre-existing divergence). Warn loudly; user must pick canonical direction.
