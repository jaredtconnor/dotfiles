# Dotfiles task runner
# https://github.com/casey/just

set windows-shell := ["pwsh", "-NoProfile", "-Command"]

# --- Installation ---

# Run full install (auto-detects OS)
[macos]
install:
    ./install-osx.sh

[linux]
install:
    ./install-linux.sh

[windows]
install:
    git -C dotbot submodule sync --quiet --recursive
    git submodule update --init --recursive dotbot
    python dotbot/bin/dotbot -d "{{justfile_directory()}}" -c install.conf.yaml

# Only create symlinks
[unix]
link:
    #!/usr/bin/env bash
    set -e
    BASEDIR="{{justfile_directory()}}"
    cd "$BASEDIR"
    git -C dotbot submodule sync --quiet --recursive
    git submodule update --init --recursive dotbot
    "$BASEDIR/dotbot/bin/dotbot" -d "$BASEDIR" -c install.conf.yaml --only link

[windows]
link:
    git -C dotbot submodule sync --quiet --recursive
    git submodule update --init --recursive dotbot
    python dotbot/bin/dotbot -d "{{justfile_directory()}}" -c install.conf.yaml --only link

# --- macOS ---

# Build karabiner.json
[macos]
karabiner:
    deno run --allow-env --allow-read --allow-write ./tools/karabiner/karabiner.ts

# Build karabiner.json in watch mode
[macos]
karabiner-dev:
    deno run --watch --allow-env --allow-read --allow-write ./tools/karabiner/karabiner.ts

# Save Homebrew packages to Brewfile
[macos]
brew:
    brew bundle dump -f --file=machines/osx/Brewfile
    brew bundle --force cleanup --file=machines/osx/Brewfile

# Restore Homebrew packages from Brewfile
[macos]
brew-restore:
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew update
    brew upgrade
    brew install mas
    brew bundle install --file=machines/osx/Brewfile
    brew cleanup

# Set macOS defaults
[macos]
macos:
    ./machines/osx/set-defaults.sh

# --- VS Code ---

# Install extensions from extensions.txt
[unix]
vscode-install:
    cat ${DOTFILES}/vscode/extensions.txt | xargs -L 1 code --install-extension

# Save current extensions to extensions.txt
vscode-save:
    code --list-extensions > {{justfile_directory()}}/editor/vscode/extensions.txt
