# PowerShell Setup Script

# Stop execution on error
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Check if Git is installed, and install if necessary using winget (Windows package manager)
if (-Not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git not found. Installing Git..."
    winget install --id Git.Git -e --source winget
}

# Install mise if not already installed
if (-Not (Get-Command mise -ErrorAction SilentlyContinue)) {
    Write-Host "mise not found. Installing mise..."
    iwr https://mise.jdx.dev/install.ps1 -useb | iex
}

# Proceed with Dotbot installation
$CONFIG = "install.conf.yaml"
$DOTBOT_DIR = "dotbot"
$DOTBOT_BIN = "tools/hg-subrepo/install.ps1"
$BASEDIR = Split-Path -Parent $MyInvocation.MyCommand.Path

# Change directory to the script's base directory
Set-Location $BASEDIR

# Update Git submodules for Dotbot
git -C $DOTBOT_DIR submodule sync --quiet --recursive
git submodule update --init --recursive $DOTBOT_DIR

# Ensure Git user email is set
$gitEmail = git config --global user.email
if (-not $gitEmail) {
    Write-Host "Git user email not set. Please configure it using the following command:"
    Write-Host 'git config --global user.email "youremail@example.com"'
    exit 1
}

# Run Dotbot setup
$dotbotCommand = Join-Path $BASEDIR "$DOTBOT_DIR\$DOTBOT_BIN"
& $dotbotCommand -d $BASEDIR -c $CONFIG

Write-Host "Dotbot installation complete."

