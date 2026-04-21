#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Terminal at Dotfiles
# @raycast.mode silent

# Optional parameters:
# @raycast.icon :terminal:
# @raycast.packageName Dotfiles

# Documentation:
# @raycast.description Opens a new terminal window at the chezmoi source directory

DOTFILES_DIR="$(chezmoi source-path 2>/dev/null || echo "$HOME/.dotfiles")"

if open -Ra "Ghostty" 2>/dev/null; then
  open -a "Ghostty" "$DOTFILES_DIR"
else
  osascript -e "tell application \"Terminal\"
    do script \"cd $DOTFILES_DIR\"
    activate
  end tell"
fi
