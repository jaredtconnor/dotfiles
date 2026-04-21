#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Bootstrap dotfiles on Windows via chezmoi.
.DESCRIPTION
    Installs chezmoi (via winget or direct download), removes any conflicting
    Dotbot symlinks/junctions, then runs chezmoi init --apply.
#>

$ErrorActionPreference = "Stop"
$Repo = "jaredtconnor/.dotfiles"
$DotfilesDir = Join-Path $env:USERPROFILE ".dotfiles"

function Write-Info  { param([string]$msg) Write-Host "=> $msg" -ForegroundColor Cyan }
function Write-Warn  { param([string]$msg) Write-Host "=> $msg" -ForegroundColor Yellow }

# ---------------------------------------------------------------------------
# 1. Install chezmoi
# ---------------------------------------------------------------------------
if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
    Write-Info "Installing chezmoi..."
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id twpayne.chezmoi --accept-source-agreements --accept-package-agreements
    } else {
        Write-Info "winget not found -- installing chezmoi via PowerShell..."
        Invoke-Expression "&{$(Invoke-RestMethod 'https://get.chezmoi.io/ps1')}"
    }
}

if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
    # Add common install locations to PATH for this session
    $env:PATH = "$env:USERPROFILE\bin;$env:LOCALAPPDATA\Programs\chezmoi;$env:PATH"
}

if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
    throw "chezmoi installation failed. Install manually: https://chezmoi.io/install/"
}

Write-Info "chezmoi installed: $(chezmoi --version)"

# ---------------------------------------------------------------------------
# 2. Remove conflicting Dotbot symlinks/junctions
# ---------------------------------------------------------------------------
function Remove-DotbotLink {
    param([string]$Path)
    if (Test-Path $Path) {
        $item = Get-Item $Path -Force -ErrorAction SilentlyContinue
        if ($item -and ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            $target = $item.Target
            if ($target -match '[\\/]\.?dotfiles[\\/]') {
                Write-Info "Removing Dotbot link: $Path -> $target"
                $item.Delete()
            }
        }
    }
}

$dotbotConf = Join-Path $DotfilesDir "install.conf.yaml"
if (Test-Path $dotbotConf) {
    Write-Info "Dotbot installation detected -- removing conflicting links..."

    # Shell configs
    @(".zshrc", ".bashrc", ".bash_profile", ".gitconfig",
      ".gitconfig-work", ".gitconfig-personal", ".tmux.conf",
      ".gitmux.conf", ".prettierrc.js", ".secrets", ".secrets.ps1") | ForEach-Object {
        Remove-DotbotLink (Join-Path $env:USERPROFILE $_)
    }

    # Directories
    @(".oh-my-zsh", ".zgenom", ".claude", ".cursor", ".hammerspoon") | ForEach-Object {
        Remove-DotbotLink (Join-Path $env:USERPROFILE $_)
    }

    # .config subdirs
    @("nvim", "LazyVim", "powershell", "ghostty", "Code/User", "zed") | ForEach-Object {
        Remove-DotbotLink (Join-Path $env:USERPROFILE ".config" $_)
    }

    # AppData entries
    @("Cursor\User\keybindings.json", "Cursor\User\settings.json") | ForEach-Object {
        Remove-DotbotLink (Join-Path $env:APPDATA $_)
    }

    # Rename old Dotbot repo
    $backup = "$DotfilesDir-legacy-$(Get-Date -Format 'yyyyMMdd')"
    Write-Info "Moving old Dotbot repo to $backup"
    Rename-Item $DotfilesDir $backup
}

# ---------------------------------------------------------------------------
# 3. Clone and apply chezmoi
# ---------------------------------------------------------------------------
if ((Test-Path (Join-Path $DotfilesDir ".git")) -and -not (Test-Path (Join-Path $DotfilesDir "install.conf.yaml"))) {
    Write-Info "Chezmoi repo already at $DotfilesDir -- updating..."
    git -C $DotfilesDir pull --ff-only origin main 2>$null
} else {
    Write-Info "Cloning $Repo to $DotfilesDir..."
    git clone "git@github.com:${Repo}.git" $DotfilesDir 2>$null
    if ($LASTEXITCODE -ne 0) {
        git clone "https://github.com/${Repo}.git" $DotfilesDir
    }
}

Write-Info "Running chezmoi init --apply..."
chezmoi init --apply --source $DotfilesDir

Write-Info "Done! Open a new shell to pick up all changes."
Write-Info "Run 'chezmoi doctor' to verify the setup."
