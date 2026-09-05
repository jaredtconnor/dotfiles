#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Browse Dotfiles
# @raycast.mode silent

# Optional parameters:
# @raycast.icon https://github.githubassets.com/favicons/favicon.png
# @raycast.packageName Dotfiles

# Documentation:
# @raycast.description Opens the dotfiles Forgejo repo in the default browser

[ -f "$HOME/.dotfiles-private/env.sh" ] && . "$HOME/.dotfiles-private/env.sh"
url="${DOTFILES_FORGEJO_WEB:-}"
[ -n "$url" ] && open "$url/dotfiles" || echo "browse-dotfiles: no companion (forgejo web url unset)"
