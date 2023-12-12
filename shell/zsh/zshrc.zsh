# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#!/usr/bin/env bash
# Get zgen
source ~/.zgenom/zgenom.zsh

export DOTFILES="$HOME/.dotfiles"
export GPG_TTY=$TTY # https://unix.stackexchange.com/a/608921

# Override compdump name: https://github.com/jandamm/zgenom/discussions/121
export ZGEN_CUSTOM_COMPDUMP="~/.zcompdump-$(whoami).zwc"

# Generate zgen init.sh if it doesn't exist
if ! zgenom saved; then
    zgenom ohmyzsh

    # Plugins
    zgenom ohmyzsh plugins/git
    zgenom ohmyzsh plugins/github
    zgenom ohmyzsh plugins/sudo
    zgenom ohmyzsh plugins/command-not-found
    zgenom ohmyzsh plugins/kubectl
    zgenom ohmyzsh plugins/docker
    zgenom ohmyzsh plugins/docker-compose
    zgenom load zsh-users/zsh-autosuggestions
    zgenom load jocelynmallon/zshmarks
    zgenom load denolfe/git-it-on.zsh
    zgenom load caarlos0/zsh-mkc
    zgenom load caarlos0/zsh-git-sync
    zgenom load caarlos0/zsh-add-upstream
    zgenom load denolfe/zsh-prepend

    zgenom load agkozak/zsh-z
    zgenom load andrewferrier/fzf-z
    zgenom load reegnz/jq-zsh-plugin

    zgenom ohmyzsh plugins/asdf

    zgenom load ntnyq/omz-plugin-pnpm

    # These 2 must be in this order
    zgenom load zsh-users/zsh-syntax-highlighting
    zgenom load zsh-users/zsh-history-substring-search

    # Set keystrokes for substring searching
    zmodload zsh/terminfo
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
    bindkey "^k" history-substring-search-up
    bindkey "^j" history-substring-search-down

    # Warn you when you run a command that you've got an alias for
    zgenom load djui/alias-tips

    # Completion-only repos
    zgenom load zsh-users/zsh-completions src

    # Theme
    zgenom load romkatv/powerlevel10k powerlevel10k

    # Generate init.sh
    zgenom save
fi

source $DOTFILES/zsh/p10k.zsh

# History Options
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history

# Share history across all your terminal windows
setopt share_history
#setopt noclobber

# set some more options
setopt pushd_ignore_dups
#setopt pushd_silent

# Increase history size
HISTSIZE=1000000000
SAVEHIST=1000000000
HISTFILE=~/.zsh_history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Return time on long running processes
REPORTTIME=2
TIMEFMT="%U user %S system %P cpu %*Es total"

# Source local zshrc if exists
test -f ~/.zshrc.local && source ~/.zshrc.local

# Place to stash environment variables
test -f ~/.secrets && source ~/.secrets

# Load functions
for f in $DOTFILES/functions/*; do source $f; done

# Load aliases
for f in $DOTFILES/aliases/*.aliases.*sh; do source $f; done

# Load all path files
for f in $DOTFILES/path/*.path.sh; do source $f; done

if type fd > /dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f'
fi

# FZF config and theme
export FZF_DEFAULT_OPTS='--reverse --bind 'ctrl-l:cancel' --height=90% --pointer='▶''
source $DOTFILES/zsh/fzf-theme-dark-plus.sh
export FZF_TMUX_HEIGHT=80%
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export EXA_ICON_SPACING=2

export BAT_THEME='Visual Studio Dark+'

export AWS_PAGER='bat -p'

# Needed for Crystal on mac - openss + pkg-config
if [ `uname` = Darwin ]; then
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/opt/openssl/lib/pkgconfig
fi

export ITERM2_SHOULD_DECORATE_PROMPT=0
source $DOTFILES/iterm2/iterm2_shell_integration.zsh

export ASDF_DOWNLOAD_PATH=bin/install
source /opt/homebrew/opt/asdf/libexec/asdf.sh
source /opt/homebrew/share/zsh/site-functions

# pnpm
export PNPM_HOME="/Users/elliot/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}  


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
)

source $ZSH/oh-my-zsh.sh 

eval "$(starship init zsh)"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# 

####################################### 
# Fedora Setup
#######################################  
export QT_QPA_PLATFORMTHEME='qt5ct'
export QT_STYLE_OVERRIDE="qt5ct"

export PATH=:$HOME/.local/bin:$PATH

# Support for two Homebrew installations
export PATH=/opt/homebrew/bin:/usr/local/bin:$PATH
alias ibrew='arch -x86_64 /usr/lcoal/bin/brew'

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi


# Pyenv Location
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

 # Do menu-driven completion.
zstyle ':completion:*' menu select

# Color completion for some things.
# http://linuxshellaccount.blogspot.com/2008/12/color-completion-using-zsh-modules-on.html
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# formatting and messages
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jaredconnor/.google_cloud/path.zsh.inc' ]; then . '/Users/jaredconnor/.google_cloud/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jaredconnor/.google_cloud/completion.zsh.inc' ]; then . '/Users/jaredconnor/.google_cloud/completion.zsh.inc'; fi

export PATH="$HOME/.poetry/bin:$PATH"

####################################### 
# GO-Lang Setup
####################################### 

export GOPATH=$HOME/go 
export PATH=$PATH:$GOPATH/bin

######################################
# Windows Terminal Setup
# Source - https://blog.jongallant.com/2020/06/wsl-ls-folder-highlight/
######################################
LS_COLORS=$LS_COLORS:'ow=1;34'; export LS_COLORS


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
