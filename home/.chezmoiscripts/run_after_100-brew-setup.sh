#!/usr/bin/env zsh

if (( ! $+commands[brew] )); then
  echo "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Updating homebrew"
  brew update
fi
