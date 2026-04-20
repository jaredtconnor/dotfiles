#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Start Claude Code
# @raycast.mode silent

# Optional parameters:
# @raycast.icon https://claude.ai/favicon.ico
# @raycast.packageName Developer
# @raycast.argument1 { "type": "text", "placeholder": "folder path", "optional": true }

# Documentation:
# @raycast.description Opens a terminal and runs claude in the specified directory

dir="${1:-$HOME}"

if open -Ra "Ghostty" 2>/dev/null; then
  open -a "Ghostty" "$dir"
  sleep 0.5
  osascript -e 'tell application "System Events" to tell process "Ghostty" to keystroke "claude\n"'
else
  osascript -e "tell application \"Terminal\"
    do script \"cd ${dir} && claude\"
    activate
  end tell"
fi
