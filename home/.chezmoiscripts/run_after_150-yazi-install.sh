#!/usr/bin/env zsh

if (( $+commands[ya] )); then
  ya pkg install || true
fi
