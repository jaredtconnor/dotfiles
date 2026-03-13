#!/usr/bin/env bash
#
# Setup tmux configuration and plugins

set -e

echo "Setting up tmux configuration and plugins..."
echo "Using local submodules from tmux-plugins directory"

# Create directory for tmux plugins if it doesn't exist
mkdir -p ~/.tmux/plugins

# Install TPM (Tmux Plugin Manager) if not already installed
if [ ! -d ~/.tmux/plugins/tpm ]; then
  echo "Installing Tmux Plugin Manager..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo "Tmux Plugin Manager already installed, updating..."
  cd ~/.tmux/plugins/tpm && git pull origin master
fi

# Link our submodule tmux plugins to the tmux plugins directory
declare -a TMUX_PLUGINS=(
  "tmux-sensible"
  "tmux-resurrect"
  "tmux-continuum"
  "vim-tmux-navigator"
  "tmux-fzf-url"
)

DOTFILES_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

for plugin_name in "${TMUX_PLUGINS[@]}"; do
  plugin_path=~/.tmux/plugins/$plugin_name
  source_path="$DOTFILES_PATH/tmux-plugins/$plugin_name"
  
  if [ -d "$source_path" ]; then
    if [ -d "$plugin_path" ] && [ ! -L "$plugin_path" ]; then
      echo "Removing existing non-symlink plugin: $plugin_name..."
      rm -rf "$plugin_path"
    fi
    
    if [ ! -L "$plugin_path" ]; then
      echo "Creating symlink for tmux plugin: $plugin_name..."
      ln -sf "$source_path" "$plugin_path"
    else
      echo "Symlink for tmux plugin already exists: $plugin_name"
    fi
  else
    echo "Warning: Source plugin not found at $source_path"
  fi
done

# Initialize tmux plugins
echo "Installing tmux plugins via TPM..."
~/.tmux/plugins/tpm/bin/install_plugins

echo "Tmux setup completed!"