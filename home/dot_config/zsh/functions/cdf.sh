#!/usr/bin/env bash

# Quick cd into specified dir, fzf picker
cdf() {
    local dir=$1
    local exa_cmd='exa -alF --icons --color=always --group-directories-first  --no-user --no-permissions --no-filesize --no-time'
    repo=$(find "$dir" -type d -maxdepth 1 -mindepth 1 | awk -F'/' '{print $NF}' | sort |
        fzf --preview "$exa_cmd $dir/{}" --preview-window 70%)
    cd "$dir"/"$repo" || return 1
}

# Jump to a git repo under ~/Code (ghq + fzf picker; see ghq.functions.sh).
dev() {
    if typeset -f repo >/dev/null 2>&1; then
        repo "$@"
    else
        cdf ~/Code
    fi
}

# Quick cd into ~/Sandbox (throwaway experiments).
sb() {
    cdf ~/Sandbox
}
