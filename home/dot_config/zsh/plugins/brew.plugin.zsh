export HOMEBREW_BUNDLE_FILE_GLOBAL="$XDG_CONFIG_HOME/homebrew/Brewfile"

function brew-dump() {
  if [[ -f $HOMEBREW_BUNDLE_FILE_GLOBAL.local ]]; then
    brew bundle dump --no-vscode --no-restart --file=- \
    | grep -E "$(brew leaves | xargs printf '%s|')tap|cask" \
    | grep -Fvx -f $HOMEBREW_BUNDLE_FILE_GLOBAL.local \
    > $HOMEBREW_BUNDLE_FILE_GLOBAL
  else
    brew bundle dump --no-vscode --no-restart --file=- \
    | grep -E "$(brew leaves | xargs printf '%s|')tap|cask" \
    > $HOMEBREW_BUNDLE_FILE_GLOBAL
  fi
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
