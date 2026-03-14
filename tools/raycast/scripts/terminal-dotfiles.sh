#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Terminal at Dotfiles
# @raycast.mode silent

# Optional parameters:
# @raycast.icon :terminal:
# @raycast.packageName Dotfiles

# Documentation:
# @raycast.description Opens a new terminal window at ~/.dotfiles

if open -Ra "Ghostty" 2>/dev/null; then
  open -a "Ghostty" ~/.dotfiles
else
  osascript -e 'tell application "Terminal"
    do script "cd ~/.dotfiles"
    activate
  end tell'
fi
