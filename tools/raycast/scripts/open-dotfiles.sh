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

if command -v cursor &>/dev/null; then
  cursor ~/.dotfiles
elif command -v code &>/dev/null; then
  code ~/.dotfiles
else
  open ~/.dotfiles
fi
