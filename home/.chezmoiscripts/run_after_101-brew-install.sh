#!/usr/bin/env zsh

if (( $+commands[brew] )); then
  echo "Installing libraries and applications with homebrew"
  brew bundle check --global || brew bundle install --global || true
fi
