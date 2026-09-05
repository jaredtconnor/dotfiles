# Zoxide environment configuration
# Sourced before zoxide init to configure exclusions
export _ZO_EXCLUDE_DIRS="$HOME/Library/CloudStorage/*:$HOME/Library/*"
export _ZO_FZF_OPTS="--height 80% --reverse --border --preview 'eza --all --git --icons --color=always {2..}' --preview-window right:50%"
