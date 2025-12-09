#!/usr/bin/env zsh

(( $+commands[claude-squad] )) && claude-squad completion zsh > ~/.config/zsh/completions/_claude-squad
(( $+commands[codex] )) && codex completion zsh > ~/.config/zsh/completions/_codex
(( $+commands[gitsnip] )) && gitsnip completion zsh > ~/.config/zsh/completions/_gitsnip
(( $+commands[llm] )) && _LLM_COMPLETE=zsh_source llm > ~/.config/zsh/completions/_llm
(( $+commands[neon] )) && neon completion > ~/.config/zsh/completions/_neon
(( $+commands[neonctl] )) && neonctl completion > ~/.config/zsh/completions/_neonctl
(( $+commands[sesh] )) && sesh completion zsh > ~/.config/zsh/completions/_sesh
(( $+commands[sops] )) && sops completion zsh > ~/.config/zsh/completions/_sops
(( $+commands[talosctl] )) && talosctl completion zsh > ~/.config/zsh/completions/_talosctl
(( $+commands[uv] )) && uv generate-shell-completion zsh > ~/.config/zsh/completions/_uv
(( $+commands[uvx] )) && uvx --generate-shell-completion zsh > ~/.config/zsh/completions/_uvx

if (( $+commands[ollama] )); then
  curl -sS https://gist.githubusercontent.com/obeone/9313811fd61a7cbb843e0001a4434c58/raw/5a6a44efc6a07b6f937dbc596d9d7385b297dda8/_ollama.zsh > ~/.config/zsh/completions/_ollama
fi

