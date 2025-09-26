#!/usr/bin/env bash
#
# Setup tmux configuration and plugins

set -e

echo "Setting up tmux configuration and plugins..."

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

# Install/update other essential tmux plugins
declare -a TMUX_PLUGINS=(
  "tmux-plugins/tmux-sensible"
  "tmux-plugins/tmux-resurrect"
  "tmux-plugins/tmux-continuum"
  "christoomey/vim-tmux-navigator"
  "wfxr/tmux-fzf-url"
)

for plugin in "${TMUX_PLUGINS[@]}"; do
  plugin_name=$(echo "$plugin" | cut -d/ -f2)
  plugin_path=~/.tmux/plugins/$plugin_name
  
  if [ ! -d "$plugin_path" ]; then
    echo "Installing tmux plugin: $plugin_name..."
    git clone https://github.com/$plugin $plugin_path
  else
    echo "Updating tmux plugin: $plugin_name..."
    cd "$plugin_path" && git pull origin master
  fi
done

# Initialize tmux plugins
echo "Installing tmux plugins via TPM..."
~/.tmux/plugins/tpm/bin/install_plugins

echo "Tmux setup completed!"