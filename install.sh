#!/usr/bin/env bash
#
# Bootstrap dotfiles on macOS or Linux.
# Idempotent -- safe to re-run at any time.
#
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
# 1. Install prerequisites (skips what's already present)
# ---------------------------------------------------------------------------
info "Detected OS: $OS"

if [[ "$OS" == "darwin" ]]; then
    if ! command_exists brew; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
    fi

    BREW_NEEDED=()
    command_exists git     || BREW_NEEDED+=(git)
    command_exists curl    || BREW_NEEDED+=(curl)
    command_exists chezmoi || BREW_NEEDED+=(chezmoi)

    if [[ ${#BREW_NEEDED[@]} -gt 0 ]]; then
        info "Installing via Homebrew: ${BREW_NEEDED[*]}"
        brew install "${BREW_NEEDED[@]}"
    fi

elif [[ "$OS" == "linux" ]]; then
    if ! command_exists git || ! command_exists curl || ! dpkg -s build-essential &>/dev/null; then
        info "Installing essentials via apt..."
        sudo apt-get update -qq
        sudo apt-get install -y -qq \
            build-essential curl wget git tmux unzip locales \
            libssl-dev zlib1g-dev libncurses5-dev libreadline-dev \
            libsqlite3-dev libbz2-dev libffi-dev liblzma-dev tk-dev
    fi

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

info "chezmoi $(chezmoi --version 2>&1 | awk '{print $3}')"

# ---------------------------------------------------------------------------
# 2. Remove conflicting Dotbot symlinks (only on first migration)
# ---------------------------------------------------------------------------
remove_dotbot_symlink() {
    local target="$1"
    if [[ -L "$target" ]]; then
        local link_dest
        link_dest="$(readlink "$target" 2>/dev/null || true)"
        case "$link_dest" in
            */.dotfiles-legacy-*|*/.dotfiles/dotbot/*|*/.dotfiles/shell/*|*/.dotfiles/tools/*|*/.dotfiles/editor/*|*/.dotfiles/terminal/*|*/.dotfiles/env/*|*/.dotfiles/ssh/*|*/.dotfiles/languages/*)
                info "Removing Dotbot symlink: $target -> $link_dest"
                rm -f "$target"
                ;;
        esac
    fi
}

is_dotbot_repo() {
    [[ -f "$DOTFILES_DIR/install.conf.yaml" ]] || [[ -d "$DOTFILES_DIR/dotbot" ]]
}

if is_dotbot_repo; then
    info "Dotbot installation detected -- removing conflicting symlinks..."

    for f in .zshrc .bashrc .bash_profile .secrets .secrets.ps1 .sharecredentials \
             .gitconfig .gitconfig-work .gitconfig-personal \
             .tmux.conf .gitmux.conf .prettierrc.js .asdfrc; do
        remove_dotbot_symlink "$HOME/$f"
    done

    remove_dotbot_symlink "$HOME/.oh-my-zsh"
    remove_dotbot_symlink "$HOME/.zgenom"
    remove_dotbot_symlink "$HOME/.ssh/config"
    remove_dotbot_symlink "$HOME/.hammerspoon"
    remove_dotbot_symlink "$HOME/Library/Application Support/com.colliderli.iina/input_conf/YouTube.conf"
    remove_dotbot_symlink "$HOME/Library/Application Support/espanso"

    for d in .claude .cursor; do
        if [[ -L "$HOME/$d" ]]; then
            remove_dotbot_symlink "$HOME/$d"
        elif [[ -d "$HOME/$d" ]]; then
            for item in "$HOME/$d"/*; do
                [[ -L "$item" ]] && remove_dotbot_symlink "$item"
            done
        fi
    done

    for d in nvim LazyVim fish mise starship.toml sesh alacritty wezterm kitty ghostty \
             sketchybar aerospace karabiner raycast/scripts powershell git/githooks \
             Code/User ccstatusline zed; do
        [[ -L "$HOME/.config/$d" ]] && remove_dotbot_symlink "$HOME/.config/$d"
    done

    if [[ -d "$HOME/bin" ]]; then
        for item in "$HOME/bin"/*; do
            [[ -L "$item" ]] && remove_dotbot_symlink "$item"
        done
    fi

    BACKUP_DIR="$HOME/.dotfiles-legacy-$(date +%Y%m%d)"
    if [[ -d "$BACKUP_DIR" ]]; then
        warn "Backup already exists at $BACKUP_DIR -- skipping move"
    else
        info "Moving old Dotbot repo to $BACKUP_DIR"
        mv "$DOTFILES_DIR" "$BACKUP_DIR"
    fi
fi

# ---------------------------------------------------------------------------
# 3. Clone (or update) and apply chezmoi
# ---------------------------------------------------------------------------
if [[ -d "$DOTFILES_DIR/.git" ]]; then
    if [[ -f "$DOTFILES_DIR/.chezmoiroot" ]]; then
        info "Chezmoi repo already at $DOTFILES_DIR -- pulling latest..."
        git -C "$DOTFILES_DIR" pull --ff-only origin main 2>/dev/null || true
    fi
else
    info "Cloning $REPO to $DOTFILES_DIR..."
    git clone "git@github.com:${REPO}.git" "$DOTFILES_DIR" 2>/dev/null \
        || git clone "https://github.com/${REPO}.git" "$DOTFILES_DIR"
fi

info "Running chezmoi init --apply..."
chezmoi init --apply --source "$DOTFILES_DIR"

info "Done! Open a new shell to pick up all changes."
info "Run 'chezmoi doctor' to verify the setup."
