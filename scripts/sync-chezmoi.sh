#!/usr/bin/env bash
# Pull canonical repositories, apply chezmoi, and summarize external updates.
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
PRIVATE_DIR="${PRIVATE_DOTFILES_DIR:-$HOME/.dotfiles-private}"
FORCE=0

if [[ "${1:-}" == "--force" ]]; then
    FORCE=1
elif [[ $# -gt 0 ]]; then
    printf 'usage: %s [--force]\n' "$0" >&2
    exit 2
fi

short_sha() {
    git -C "$1" rev-parse --short=7 HEAD
}

sync_repo() {
    local label="$1"
    local path="$2"
    local before after output

    [[ -d "$path/.git" ]] || return 0
    before="$(short_sha "$path")"
    if ! output="$(git -C "$path" pull --ff-only origin main 2>&1)"; then
        printf '  %s: FAILED\n' "$label" >&2
        printf '%s\n' "$output" | sed 's/^/    /' >&2
        return 1
    fi
    after="$(short_sha "$path")"

    if [[ "$before" == "$after" ]]; then
        printf '  %s: current @ %s\n' "$label" "$after"
    else
        printf '  %s: updated %s -> %s\n' "$label" "$before" "$after"
    fi
}

render_external_inventory() {
    chezmoi execute-template <"$DOTFILES_DIR/home/.chezmoiexternal.toml.tmpl" |
        awk '
            /^\[".*"\]$/ {
                path = substr($0, 3, length($0) - 4)
                next
            }
            /^[[:space:]]*type[[:space:]]*=[[:space:]]*"git-repo"/ {
                print "git\t" path
                next
            }
            /^[[:space:]]*type[[:space:]]*=[[:space:]]*"archive"/ {
                print "archive\t" path
            }
        '
}

filter_success_output() {
    awk '
        /^Already up to date\.$/ { next }
        /^From / { next }
        /^[[:space:]]+\* branch[[:space:]].*->[[:space:]]FETCH_HEAD$/ { next }
        /->[[:space:]]*origin\// { next }
        /^Updating [0-9a-f]+\.\.[0-9a-f]+$/ { next }
        /^Fast-forward$/ { git_summary = 1; next }
        git_summary && /^[[:space:]].*\|/ { next }
        git_summary && /^[[:space:]]*[0-9]+ files? changed/ {
            git_summary = 0
            next
        }
        /^[[:space:]]*(create|delete) mode [0-9]+ / { next }
        /^[[:space:]]*rename .* \([0-9]+%\)$/ { next }
        { print }
    '
}

printf 'Repositories:\n'
sync_repo "dotfiles" "$DOTFILES_DIR"
sync_repo "private companion" "$PRIVATE_DIR"

init_args=(--source "$DOTFILES_DIR")
apply_args=(--refresh-externals)
if [[ "$FORCE" -eq 1 ]]; then
    init_args=(--no-tty "${init_args[@]}")
    apply_args=(--no-tty --force "${apply_args[@]}")
fi
chezmoi init "${init_args[@]}"

inventory="$(mktemp)"
apply_output="$(mktemp)"
before_inventory="$(mktemp)"
trap 'rm -f "$inventory" "$apply_output" "$before_inventory"' EXIT
render_external_inventory >"$inventory"

declare -a git_paths=()
archive_count=0
while IFS=$'\t' read -r kind path; do
    [[ -n "$path" ]] || continue
    if [[ "$kind" == "git" ]]; then
        git_paths+=("$path")
    else
        archive_count=$((archive_count + 1))
    fi
done <"$inventory"

for path in "${git_paths[@]}"; do
    if [[ -d "$HOME/$path/.git" ]]; then
        printf '%s\t%s\n' "$path" "$(short_sha "$HOME/$path")" >>"$before_inventory"
    else
        printf '%s\t-\n' "$path" >>"$before_inventory"
    fi
done

printf 'Chezmoi: applying managed files and refreshing externals...\n'
if ! chezmoi apply "${apply_args[@]}" >"$apply_output" 2>&1; then
    printf 'Chezmoi apply failed:\n' >&2
    sed 's/^/  /' "$apply_output" >&2
    exit 1
fi

filter_success_output <"$apply_output"

updated=0
cloned=0
current=0
missing=0
changes=()
for path in "${git_paths[@]}"; do
    before="$(awk -F '\t' -v key="$path" '$1 == key { print $2; exit }' "$before_inventory")"
    if [[ ! -d "$HOME/$path/.git" ]]; then
        missing=$((missing + 1))
        changes+=("  $path: not present")
        continue
    fi
    after="$(short_sha "$HOME/$path")"
    if [[ "$before" == "-" ]]; then
        cloned=$((cloned + 1))
        changes+=("  $path: cloned @ $after")
    elif [[ "$before" != "$after" ]]; then
        commit_count="$(git -C "$HOME/$path" rev-list --count "$before..$after")"
        subject="$(git -C "$HOME/$path" log -1 --format=%s "$after")"
        updated=$((updated + 1))
        if [[ "$commit_count" -eq 1 ]]; then
            commit_label="commit"
        else
            commit_label="commits"
        fi
        changes+=("  $path: updated $before -> $after ($commit_count $commit_label)")
        changes+=("    $after $subject")
    else
        current=$((current + 1))
    fi
done

printf 'Externals: %d Git checked' "${#git_paths[@]}"
[[ "$updated" -gt 0 ]] && printf ', %d updated' "$updated"
[[ "$cloned" -gt 0 ]] && printf ', %d cloned' "$cloned"
[[ "$current" -gt 0 ]] && printf ', %d current' "$current"
[[ "$missing" -gt 0 ]] && printf ', %d unavailable' "$missing"
[[ "$archive_count" -gt 0 ]] && printf '; %d archives managed' "$archive_count"
printf '\n'
if [[ "${#changes[@]}" -gt 0 ]]; then
    printf '%s\n' "${changes[@]}"
fi
