#!/usr/bin/env zsh

if ! command -v brew &>/dev/null; then
  echo "Installing hmebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if command -v brew &>/dev/null; then
  echo "Installing libaries and applications with homebrew"
  $HOMEBREW_PREFIX/bin/brew bundle install --global || true
fi
