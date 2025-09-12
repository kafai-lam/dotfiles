#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Update Dotfiles
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ⊙

# Documentation:
# @raycast.description Update Dotfiles
# @raycast.author kafai-lam
# @raycast.authorURL https://raycast.com/kafai-lam

: ${HOMEBREW_BUNDLE_FILE_GLOBAL:=$HOME/.config/homebrew/Brewfile}

brew-dump () {
    if [[ -f $HOMEBREW_BUNDLE_FILE_GLOBAL.local ]]
    then
        brew bundle dump --no-vscode --no-restart --file=- | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn} -E "$(brew leaves | xargs printf '%s|')tap|cask" | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn} -Fvx -f $HOMEBREW_BUNDLE_FILE_GLOBAL.local > $HOMEBREW_BUNDLE_FILE_GLOBAL
    else
        brew bundle dump --no-vscode --no-restart --file=- | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn} -E "$(brew leaves | xargs printf '%s|')tap|cask" > $HOMEBREW_BUNDLE_FILE_GLOBAL
    fi
}

update_dotfiles() {
    brew-dump
    chezmoi re-add
}

update_dotfiles
