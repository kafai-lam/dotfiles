#!/usr/bin/env zsh

if (( $+commands[mise] )); then
  echo "Installing packages with mise"
  mise install --cd $HOME || true
  mise upgrade
else
  echo "Missing mise. Skipping mise install"
fi
