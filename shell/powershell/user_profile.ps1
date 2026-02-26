# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Import-Module posh-git
$omp_config = Join-Path $PSScriptRoot ".\jconnor.omp.json"
oh-my-posh --init --shell pwsh --config $omp_config | Invoke-Expression

Import-Module -Name Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
try { Set-PSReadLineOption -PredictionSource History } catch {}

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Env
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

# Load secrets if present
$secretsFile = Join-Path $HOME ".secrets.ps1"
if (Test-Path $secretsFile) {
    . $secretsFile
}

# Alias
Set-Alias -Name vim -Value nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'

# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
  Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function Get-FilteredDir {
  param(
    [string]$Path = ".",
    [string[]]$Exclude = @('\.git', 'node_modules', '\.env', 'bin', 'obj', '__pycache__', '\.vs', 'dist', 'build', '.\.azure')
  )
    
  $excludeRegex = '\\(' + ($Exclude -join '|') + ')($|\\)'
  Get-ChildItem $Path -Recurse -Force | Where-Object { 
    $_.FullName -notmatch $excludeRegex 
  }
}

Set-Alias -Name lsf -Value Get-FilteredDir
