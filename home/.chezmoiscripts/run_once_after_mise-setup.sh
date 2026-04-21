#!/usr/bin/env bash
#
# One-shot mise install. Runs after config.toml is in place (after_ prefix).
# Installs all tool versions defined in ~/.config/mise/config.toml.
# Non-fatal: individual tool failures are logged but don't block chezmoi apply.
#

set -uo pipefail

if ! command -v mise &>/dev/null; then
    echo "mise not found -- skipping (https://mise.jdx.dev)"
    exit 0
fi

echo "Running mise install..."
if mise install --yes 2>&1; then
    echo "mise install complete"
else
    echo "WARNING: mise install had failures (see above). Run 'mise install' manually to retry."
fi

exit 0
