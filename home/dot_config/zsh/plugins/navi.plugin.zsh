#!/usr/bin/env zsh

if (( ! $+commands[navi] )); then
  return
fi

eval "$(navi widget zsh)"
