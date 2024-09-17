# source $DOTFILES/shell/zsh/p10k.zsh 
eval "$(starship init zsh)"

#!/usr/bin/env bash
# Get zgen
source ~/.zgenom/zgenom.zsh
 
eval "$(/opt/homebrew/bin/brew shellenv)"

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

    zgenom load zsh-users/zsh-autosuggestions
    zgenom load zsh-users/zsh-completions 

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

    # Generate init.sh
    zgenom save
fi


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
setopt sharehistory 
#setopt noclobber

# set some more options
setopt pushd_ignore_dups

# Increase history size
HISTSIZE=1000000000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history 
HISDUP=erase 
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Return time on long running processes
REPORTTIME=2
TIMEFMT="%U user %S system %P cpu %*Es total"

# Source local zshrc if exists
test -f ~/.zshrc.local && source ~/.zshrc.local

# Place to stash environment variables
test -f ~/.secrets && source ~/.secrets

# Load functions
for f in $DOTFILES/shell/functions/*; do source $f; done

# Load aliases
for f in $DOTFILES/shell/aliases/*.aliases.*sh; do source $f; done

# Load all path files
for f in $DOTFILES/shell/paths/*.path.sh; do source $f; done

if type fd > /dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f'
fi

# FZF config and theme
export FZF_DEFAULT_OPTS='--reverse --bind 'ctrl-l:cancel' --height=90% --pointer='▶''
source $DOTFILES/shell/zsh/fzf-theme-dark-plus.sh
export FZF_TMUX_HEIGHT=80%
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export BAT_THEME='Visual Studio Dark+'

export AWS_PAGER='bat -p'

# Needed for Crystal on mac - openss + pkg-config
if [ `uname` = Darwin ]; then
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/opt/openssl/lib/pkgconfig
fi

export ASDF_DOWNLOAD_PATH=bin/install
source /opt/homebrew/opt/asdf/libexec/asdf.sh
source /opt/homebrew/share/zsh/site-functions

# pnpm
export PNPM_HOME="/Users/jaredconnor/Library/pnpm"
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



# Support for two Homebrew installations
export PATH=/opt/homebrew/bin:/usr/local/bin:$PATH
alias ibrew='arch -x86_64 /usr/lcoal/bin/brew'

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

####################################### 
# GO-Lang Setup
####################################### 

export GOPATH=$HOME/go 
export PATH=$PATH:$GOPATH/bin 

####################################### 
# Deno setup
####################################### 
export PATH="$DENO_INSTALL/bin:$PATH"

bindkey -s ^a "nvims\n"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "/Users/jaredconnor/.bun/_bun" ] && source "/Users/jaredconnor/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
