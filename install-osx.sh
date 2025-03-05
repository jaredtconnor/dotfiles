#!/usr/bin/env bash

set -e

# **macOS-Specific Setup**

# Install Homebrew if not already installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew and install essential packages
brew update
brew install \
  git \
  wget \
  curl \
  unzip
# Add other essential packages here

# Set locale to prevent warnings (if necessary)
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8

# **End of macOS-Specific Setup**

# Proceed with Dotbot installation
CONFIG="install.conf.yaml"
DOTBOT_DIR="dotbot"

DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASEDIR}"
git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
git submodule update --init --recursive "${DOTBOT_DIR}"

# Ensure Git user email is set
if ! git config --global user.email >/dev/null; then
  echo "Git user email not set. Please configure it using:"
  echo "git config --global user.email 'jaredconnor@fastmail.com'"
  exit 1
fi

# Initialize ASDF within the script to ensure plugins are available
if [ -f "$HOME/.asdf/asdf.sh" ]; then
  . "$HOME/.asdf/asdf.sh"
fi

"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" \
  --plugin-dir dotbot-plugins/dotbot-asdf \
  -c "${CONFIG}" "${@}"   
