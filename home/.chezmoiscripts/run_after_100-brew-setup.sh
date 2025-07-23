#!/usr/bin/env zsh

if ! command -v brew &>/dev/null; then
  echo "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Updating homebrew"
  brew update
fi
