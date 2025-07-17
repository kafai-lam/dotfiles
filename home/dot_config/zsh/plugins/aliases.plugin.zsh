#!/usr/bin/env zsh

alias zshrc="$EDITOR ~/.zshrc"

(( $+commands[brew] )) && alias b="brew"
(( $+commands[lazydocker] )) && alias ldk="lazydocker"
(( $+commands[lazygit] )) && alias lg="lazygit"
(( $+commands[nvim] )) && alias vim="nvim"
(( $+commands[terraform] )) && alias tf="terraform"
(( $+commands[yazi] )) && alias y="yazi"

if (( $+commands[bat] )); then
  alias cat="bat"
elif (( $+commands[batcat] )); then
  alias cat="batcat"
fi

if (( $+commands[chezmoi] )); then
  alias ch="chezmoi"
  alias chcd="cd $(chezmoi source-path)"
  alias ched="$EDITOR $(chezmoi source-path)"
fi

# Define functions and completions.
md() {
  [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1"
}

dotenv-source() {
  dotenv_file="${1:-.env}"
  [[ -f $dotenv_file ]] && set -a && source $dotenv_file && set +a
}

