#!/usr/bin/env zsh

if command -v ya &>/dev/null; then
  ya pkg install || true
fi
