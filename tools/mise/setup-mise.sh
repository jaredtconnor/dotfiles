#!/usr/bin/env bash

# This script installs and configures mise runtime versions
# It should be run after dotbot has set up the necessary config files

set -e

CONFIG_DIR="$HOME/.config/mise"
mkdir -p "$CONFIG_DIR"

# Ensure mise is installed and in PATH
if ! command -v mise >/dev/null 2>&1; then
  echo "Installing mise..."
  if [[ "$(uname)" == "Darwin" ]]; then
    brew install mise
  else
    curl https://mise.jdx.dev/install.sh | sh
  fi
  
  # Add mise to PATH for the current script
  if [[ -f "$HOME/.local/bin/mise" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi

# Initialize mise in the current shell
eval "$(mise activate bash)"

echo "Installing runtime versions from config.toml..."
mise install

echo "Verifying installations..."
mise list

echo "mise setup completed successfully!"
echo ""
echo "IMPORTANT: Make sure to add this to your shell config:"
echo 'eval "$(mise activate zsh)"  # or bash'
echo ""
echo "Then restart your shell or run: source ~/.zshrc"