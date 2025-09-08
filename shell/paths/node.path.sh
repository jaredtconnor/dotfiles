#!/usr/bin/env bash

# Needed for asdf to work with global packages
# https://github.com/asdf-vm/asdf-nodejs/issues/42#issuecomment-386783059

export PATH="$PATH:$HOME/.yarn/bin" 

export PNPM_HOME=/Users/jaredconnor/Library/pnpm/ 

export PATH="$PATH:$PNPM_HOME"
export PATH="$PATH:$HOME/.npm-global/bin"
