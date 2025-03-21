#!/usr/bin/env zsh

if (( ! $+commands[go] )); then
  return
fi

path+=(
  $(go env GOPATH)/bin
)
