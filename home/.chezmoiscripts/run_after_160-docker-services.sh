#!/usr/bin/env zsh

if (( $+commands[orbctl] )); then
  echo "Starting orb"
  orbctl start

  docker compose --project-name homelab --file ~/.config/services/compose.yaml pull
  docker compose --project-name homelab --file ~/.config/services/compose.yaml up --detach --force-recreate
else
  echo "Missing orbstack. Skipping orbctl start"
fi

