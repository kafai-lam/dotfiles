#!/usr/bin/env zsh

if (( $+commands[ya] )); then
  echo "Installing yazi plugins"
  ya pkg install > /dev/null 2>&1 || true
fi
