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

if (( $+commands[kubectl] )); then
  alias k="kubectl"
  alias ka="kubectl apply"
  alias kaf="kubectl apply -f"
  alias kdel="kubectl delete"
  alias kdelf="kubectl delete -f"
  alias krr='kubectl rollout restart'
  alias kcuc="kubectl config use-context"
  alias kcsc="kubectl config set-context"
  alias kcdc="kubectl config delete-context"
  alias kccc="kubectl config current-context"
  alias kcgc="kubectl config get-contexts"

  (( $+commands[k9s] ))&& alias ks="k9s"
  (( $+commands[kubectx] )) && alias kc="kubectx"
  (( $+commands[kubens] )) && alias kns="kubens"
fi

# Define functions and completions.
md() {
  [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1"
}

dotenv-source() {
  dotenv_file="${1:-.env}"
  [[ -f $dotenv_file ]] && set -a && source $dotenv_file && set +a
}

