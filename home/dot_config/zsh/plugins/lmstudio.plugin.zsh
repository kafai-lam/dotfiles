#!/usr/bin/env zsh

if (( ! $+commands[lms] )); then
  return
fi

path+=(
  $HOME/.lmstudio/bin
)
