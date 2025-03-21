#!/usr/bin/env zsh

if (( ! $+commands[mise] )); then
  return
fi

eval "$(mise activate zsh)"
