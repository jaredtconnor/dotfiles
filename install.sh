#!/usr/bin/env bash
set -euo pipefail

REPO="jaredtconnor/.dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
info()  { printf '\033[1;34m=> %s\033[0m\n' "$*"; }
warn()  { printf '\033[1;33m=> %s\033[0m\n' "$*"; }
fail()  { printf '\033[1;31m=> %s\033[0m\n' "$*"; exit 1; }

command_exists() { command -v "$1" &>/dev/null; }

# ---------------------------------------------------------------------------
# OS detection
# ---------------------------------------------------------------------------
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "darwin" ;;
        Linux*)  echo "linux"  ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *)       fail "Unsupported OS: $(uname -s)" ;;
    esac
}

OS="$(detect_os)"

if [[ "$OS" == "windows" ]]; then
    warn "Windows detected. Run install.ps1 in PowerShell instead."
    exit 1
fi

# ---------------------------------------------------------------------------
# 1. Install prerequisites
# ---------------------------------------------------------------------------
info "Detected OS: $OS"

if [[ "$OS" == "darwin" ]]; then
    if ! command_exists brew; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
    fi
    info "Installing essentials via Homebrew..."
    brew install git curl chezmoi 2>/dev/null || true

elif [[ "$OS" == "linux" ]]; then
    info "Installing essentials via apt..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq \
        build-essential curl wget git tmux unzip locales \
        libssl-dev zlib1g-dev libncurses5-dev libreadline-dev \
        libsqlite3-dev libbz2-dev libffi-dev liblzma-dev tk-dev

    sudo locale-gen en_US.UTF-8 2>/dev/null || true
    sudo update-locale LANG=en_US.UTF-8 2>/dev/null || true
    export LANG=en_US.UTF-8

    if ! command_exists chezmoi; then
        info "Installing chezmoi..."
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
        export PATH="$HOME/.local/bin:$PATH"
    fi
fi

if ! command_exists chezmoi; then
    fail "chezmoi installation failed"
fi

info "chezmoi $(chezmoi --version | head -1)"

# ---------------------------------------------------------------------------
# 2. Remove conflicting Dotbot symlinks
# ---------------------------------------------------------------------------
remove_dotbot_symlink() {
    local target="$1"
    if [[ -L "$target" ]]; then
        local link_dest
        link_dest="$(readlink "$target" 2>/dev/null || true)"
        if [[ "$link_dest" == */.dotfiles/* || "$link_dest" == */dotfiles/* ]]; then
            info "Removing Dotbot symlink: $target -> $link_dest"
            rm -f "$target"
        fi
    fi
}

remove_dotbot_dir_symlink() {
    local target="$1"
    if [[ -L "$target" ]]; then
        local link_dest
        link_dest="$(readlink "$target" 2>/dev/null || true)"
        if [[ "$link_dest" == */.dotfiles/* || "$link_dest" == */dotfiles/* ]]; then
            info "Removing Dotbot symlink: $target -> $link_dest"
            rm -f "$target"
        fi
    fi
}

if [[ -f "$HOME/.dotfiles/install.conf.yaml" ]] || [[ -d "$HOME/.dotfiles/dotbot" ]]; then
    info "Dotbot installation detected -- removing conflicting symlinks..."

    # Shell
    for f in .zshrc .bashrc .bash_profile .secrets .secrets.ps1 .sharecredentials; do
        remove_dotbot_symlink "$HOME/$f"
    done

    # ZSH frameworks (these become chezmoi externals)
    remove_dotbot_dir_symlink "$HOME/.oh-my-zsh"
    remove_dotbot_dir_symlink "$HOME/.zgenom"

    # Git
    for f in .gitconfig .gitconfig-work .gitconfig-personal; do
        remove_dotbot_symlink "$HOME/$f"
    done

    # Tools
    for f in .tmux.conf .gitmux.conf .prettierrc.js; do
        remove_dotbot_symlink "$HOME/$f"
    done

    # SSH
    remove_dotbot_symlink "$HOME/.ssh/config"

    # AI tooling
    for d in .claude .cursor; do
        if [[ -L "$HOME/$d" ]]; then
            remove_dotbot_dir_symlink "$HOME/$d"
        elif [[ -d "$HOME/$d" ]]; then
            for item in "$HOME/$d"/*; do
                [[ -L "$item" ]] && remove_dotbot_symlink "$item"
            done
        fi
    done

    # ~/.config entries
    for d in nvim LazyVim fish mise starship.toml sesh alacritty wezterm kitty ghostty \
             sketchybar aerospace karabiner raycast/scripts powershell git/githooks \
             Code/User ccstatusline zed; do
        target="$HOME/.config/$d"
        if [[ -L "$target" ]]; then
            remove_dotbot_dir_symlink "$target"
        fi
    done

    # macOS-specific
    remove_dotbot_dir_symlink "$HOME/.hammerspoon"
    remove_dotbot_symlink "$HOME/Library/Application Support/com.colliderli.iina/input_conf/YouTube.conf"
    remove_dotbot_dir_symlink "$HOME/Library/Application Support/espanso"

    # ~/bin scripts
    if [[ -d "$HOME/bin" ]]; then
        for item in "$HOME/bin"/*; do
            [[ -L "$item" ]] && remove_dotbot_symlink "$item"
        done
    fi

    # Rename old Dotbot repo out of the way
    if [[ -f "$HOME/.dotfiles/install.conf.yaml" ]]; then
        BACKUP_DIR="$HOME/.dotfiles-legacy-$(date +%Y%m%d)"
        info "Moving old Dotbot repo to $BACKUP_DIR"
        mv "$HOME/.dotfiles" "$BACKUP_DIR"
    fi
fi

# ---------------------------------------------------------------------------
# 3. Clone and apply chezmoi
# ---------------------------------------------------------------------------
if [[ -d "$DOTFILES_DIR/.git" ]] && ! [[ -f "$DOTFILES_DIR/install.conf.yaml" ]]; then
    info "Chezmoi repo already at $DOTFILES_DIR -- updating..."
    git -C "$DOTFILES_DIR" pull --ff-only origin main 2>/dev/null || true
else
    info "Cloning $REPO to $DOTFILES_DIR..."
    git clone "git@github.com:${REPO}.git" "$DOTFILES_DIR" 2>/dev/null \
        || git clone "https://github.com/${REPO}.git" "$DOTFILES_DIR"
fi

info "Running chezmoi init --apply..."
chezmoi init --apply --source "$DOTFILES_DIR"

info "Done! Open a new shell to pick up all changes."
info "Run 'chezmoi doctor' to verify the setup."
