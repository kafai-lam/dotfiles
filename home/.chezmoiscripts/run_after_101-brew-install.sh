#!/usr/bin/env zsh

if command -v brew &>/dev/null; then
  echo "Installing libraries and applications with homebrew"
  brew bundle check --global || brew bundle install --global || true
fi
