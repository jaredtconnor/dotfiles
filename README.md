# Dotfiles

> Personal dotfiles configuration for cross-platform development environments, featuring Zsh, Git, Neovim, VSCode, and more to rapidly bootstrap a new system on macOS, Linux, or Windows.

![Image](preview.png)

## Overview

This repository contains my personal dotfiles configuration, designed to quickly set up consistent development environments across multiple platforms. The configuration uses [Dotbot](https://github.com/anishathalye/dotbot) for installation and management of symlinks.

## Components

| Component       | Tool                                                                        | Config                                 |
| --------------- | --------------------------------------------------------------------------- | -------------------------------------- |
| Installation    | [Dotbot](https://github.com/anishathalye/dotbot)                            | [config](./install.conf.yaml)          |
| Shell           | [Zsh](https://www.zsh.org/)                                                 | [config](./shell/zsh/)                 |
| Prompt          | [Starship](https://starship.rs/)                                            | [config](./shell/starship.toml)        |
| Shell Framework | [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)                      | [config](./zsh/zshrc.zsh)              |
| Version Manager | [mise](https://github.com/jdx/mise) (formerly rtx)                          | [config](./tools/mise/)                |
| Terminal        | [Alacritty](https://alacritty.org/), [Kitty](https://sw.kovidgoyal.net/kitty/), [Wezterm](https://wezfurlong.org/wezterm/) | [config](./terminal/)                 |
| Multiplexer     | [Tmux](https://github.com/tmux/tmux/wiki)                                   | [config](./tools/tmux/)                |
| Editor          | [NeoVim](https://neovim.io/), [LazyVim](https://github.com/LazyVim/LazyVim), [LunarVim](https://www.lunarvim.org/) | [config](./editor/)                   |
| IDE             | [VS Code](https://code.visualstudio.com/), [Zed](https://zed.dev/)          | [config](./editor/vscode/), [config](./editor/zed/) |
| Git             | [Git](https://git-scm.com/)                                                 | [config](./tools/git/)                 |

## Features

- **Cross-platform support**: Works on macOS, Linux (Fedora), and Windows
- **Modular design**: Organized by tool and functionality
- **Smart installation**: Detects OS and installs appropriate configurations
- **Editor configurations**: Multiple editor setups (NeoVim, VS Code, LazyVim, LunarVim, Zed)
- **Terminal customization**: Configurations for multiple terminal emulators
- **Development tools**: Node.js, Git, tmux and more
- **Shell aliases**: Organized by function (git, node, vim, tools, etc.)
- **Machine-specific configs**: Separate setups for different machines (macOS, Fedora)

## Makefile Commands

The included [Makefile](./Makefile) provides several useful commands:

- `make install`: Detects OS and runs the appropriate installation script
- `make install-osx`: Runs macOS-specific installation
- `make install-linux`: Runs Linux-specific installation
- `make install-windows`: Runs Windows-specific installation
- `make link`: Only creates symlinks without running other setup steps
- `make vscode-install`: Installs VS Code extensions from the extensions list
- `make vscode-save`: Saves currently installed VS Code extensions to list
- `make brew`: Dumps current Homebrew packages to Brewfile
- `make karabiner`: Generates karabiner.json configuration (macOS only)

## Setup & Installation

### Prerequisites

- Python 3+
- Git
- Zsh
- curl / wget (for downloading additional tools)

### Installation Steps

1. Clone this repository (with submodules):
```sh
git clone git@github.com:jaredtconnor/dotfiles.git ~/.dotfiles --recursive
cd ~/.dotfiles
```

2. Run the installation:
```sh
make install
```

This will:
- Detect your OS and run the appropriate installation script
- Install required packages via Homebrew (macOS) or package manager (Linux)
- Create symlinks for all configuration files
- Install additional tools and plugins

### Platform-Specific Setup

#### macOS
- Installs Homebrew and packages from Brewfile
- Sets up macOS-specific configurations
- Configures Karabiner Elements for keyboard customization

#### Linux (Fedora)
- Installs necessary packages
- Sets up Linux-specific configurations

#### Manual Steps After Installation

1. Install your preferred terminal emulator if not already installed
2. Install any additional VS Code extensions not covered by the automatic setup
3. Set up any machine-specific configurations not included in the default install

## Directory Structure

- `dotbot/`: Dotbot installation tool
- `dotbot-plugins/`: Plugins for Dotbot
- `editor/`: Editor configurations (NeoVim, VS Code, LazyVim, etc.)
- `languages/`: Language-specific configurations and tools
- `machines/`: Machine-specific configurations (Fedora, macOS)
- `shell/`: Shell configurations, including aliases and functions
- `terminal/`: Terminal emulator configurations
- `tools/`: Configurations for various development tools
- `mcp/`: Machine Context Protocol configurations for AI assistants
- `ssh/`: SSH configuration

## Shell Aliases and Scripts

The repository contains numerous helpful shell aliases and custom scripts:

### Aliases

The aliases are organized by functionality:

- **Git aliases** (`shell/aliases/git.aliases.sh`): Shortcuts for common Git operations
- **Node aliases** (`shell/aliases/node.aliases.sh`): Node.js and JavaScript development helpers
- **Vim aliases** (`shell/aliases/vim.aliases.sh`): Vim and Neovim shortcuts
- **Tools aliases** (`shell/aliases/tools.aliases.sh`): General development tool shortcuts
- **Zsh aliases** (`shell/aliases/zsh.aliases.sh`): Zsh-specific helpers
- **Fedora aliases** (`shell/aliases/fedora.aliases.sh`): Fedora Linux specific commands

### Custom Scripts

The `shell/bin/` directory contains numerous helpful scripts:

- Git workflow helpers (`git-*`)
- Development utilities
- System management tools
- And more

## Terminal Emulators

This configuration supports multiple terminal emulators:

- **Alacritty**: GPU-accelerated terminal emulator (config in `terminal/alacritty/`)
- **Kitty**: Fast, feature-rich terminal emulator (config in `terminal/kitty/`)
- **Wezterm**: GPU-accelerated terminal with advanced features (config in `terminal/wezterm/`)
- **Ghostty**: Modern terminal emulator (config in `terminal/ghostty/`)

## Editor Configurations

### Neovim & Variants

- **Neovim**: Base configuration with modern plugins
- **LazyVim**: Opinionated Neovim configuration with lazy package management
- **LunarVim**: IDE-like Neovim setup

### VS Code

Configuration includes:
- Extensions list
- User settings
- Keybindings
- Snippets

### Zed Editor

Modern editor configuration with:
- Custom keymaps
- Settings

## Customization

Fork this repository and modify any configurations to suit your preferences. The modular organization makes it easy to add, remove, or modify components as needed.

## Acknowledgements

- [Dotbot](https://github.com/anishathalye/dotbot) for installation management
- Various plugin authors and tool creators
- The dotfiles community for inspiration and ideas
