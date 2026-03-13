FPATH=opt/homebrew/share/zsh/site-functions:$FPATH
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

# Set CLICOLOR if you want Ansi Colors in iTerm2 
export CLICOLOR=1

# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

eval $(/opt/homebrew/bin/brew shellenv)
eval "$(/opt/homebrew/bin/brew shellenv)"
eval $(/opt/homebrew/bin/brew shellenv)

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
