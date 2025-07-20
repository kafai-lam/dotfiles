#!/usr/bin/env zsh

brew-dump() {
  brew bundle dump --no-vscode --no-restart --file=- | egrep "$(brew leaves | xargs printf '"%s"|')tap|cask" > $HOMEBREW_BUNDLE_FILE_GLOBAL
}

function brews() {
  local formulae="$(brew leaves | xargs brew deps --installed --for-each)"
  local casks="$(brew list --cask 2>/dev/null)"

  local blue="$(tput setaf 4)"
  local bold="$(tput bold)"
  local off="$(tput sgr0)"

  echo "${blue}==>${off} ${bold}Formulae${off}"
  echo "${formulae}" | sed "s/^\(.*\):\(.*\)$/\1${blue}\2${off}/"
  echo "\n${blue}==>${off} ${bold}Casks${off}\n${casks}"
}
