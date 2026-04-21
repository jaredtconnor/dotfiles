#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Dotfiles
# @raycast.mode silent

# Optional parameters:
# @raycast.icon :wrench:
# @raycast.packageName Dotfiles

# Documentation:
# @raycast.description Opens dotfiles repo in Cursor, VS Code, or Finder

DOTFILES_DIR="$(chezmoi source-path 2>/dev/null || echo "$HOME/.dotfiles")"

if command -v cursor &>/dev/null; then
  cursor "$DOTFILES_DIR"
elif command -v code &>/dev/null; then
  code "$DOTFILES_DIR"
else
  open "$DOTFILES_DIR"
fi
