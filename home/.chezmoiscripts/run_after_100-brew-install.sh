#!/usr/bin/env zsh

if ! command -v brew &>/dev/null; then
  echo "Installing hmebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if command -v brew &>/dev/null; then
  echo "Installing libaries and applications with homebrew"
  NONINTERACTIVE=1 $HOMEBREW_PREFIX/bin/brew bundle install --global || true
fi
