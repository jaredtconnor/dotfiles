#!/usr/bin/env bash

set -e

# **Linux-Specific Setup**

# # Unset LC_ALL to prevent interference with locale configuration
unset LC_ALL

# Generate the en_US.UTF-8 locale
sudo locale-gen en_US.UTF-8

# Update locale settings
sudo update-locale LANG=en_US.UTF-8

# Export locale environment variables for the current session
export LANG=en_US.UTF-8
export LANGUAGE=en_US

# Initialize mise for the script if available
if [ -f "$HOME/.local/bin/mise" ]; then
  eval "$($HOME/.local/bin/mise activate bash)"
elif command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

# Ensure necessary packages are installed
sudo apt-get update
sudo apt-get install -y \
  build-essential \
  curl \
  wget \
  git \
  tmux \
  unzip \
  locales
# Add other essential packages here

# Set locale to prevent warnings
sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8

# Reload locale settings
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8

# Install build dependencies for Python (if using ASDF to install Python)
sudo apt-get install -y \
  libssl-dev \
  zlib1g-dev \
  libncurses5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libbz2-dev \
  libffi-dev \
  liblzma-dev \
  tk-dev
# Add other Python build dependencies if needed

# Install mise if not already installed
if ! command -v mise >/dev/null 2>&1; then
  echo "Installing mise..."
  curl https://mise.jdx.dev/install.sh | sh
fi

# **End of Linux-Specific Setup**

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

# Make sure mise is in the PATH
export PATH="$HOME/.local/bin:$PATH"

"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" \
  -c "${CONFIG}" "${@}"
