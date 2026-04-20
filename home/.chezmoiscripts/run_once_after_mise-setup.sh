#!/usr/bin/env bash
#
# One-shot mise install. Runs after config.toml is in place (after_ prefix).
# Installs all tool versions defined in ~/.config/mise/config.toml.
#

set -euo pipefail

if ! command -v mise &>/dev/null; then
    echo "mise not found -- install it first (https://mise.jdx.dev)"
    exit 0
fi

echo "Running mise install..."
mise install --yes
echo "mise install complete"
