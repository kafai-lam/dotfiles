#!/usr/bin/env zsh

if (( $+commands[duti] )); then
  echo "Set default uti with duti"
  duti $XDG_CONFIG_HOME/duti/config.duti || true
fi
