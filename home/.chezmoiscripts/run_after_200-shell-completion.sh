#!/usr/bin/env zsh

# Ensure completions directory exists (respect XDG when available).
COMPDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions"
mkdir -p -- "$COMPDIR"

(( $+commands[claude-squad] )) && { (claude-squad completion zsh > "$COMPDIR/_claude-squad") 2>/dev/null || true; }
(( $+commands[codex] )) && { (codex completion zsh > "$COMPDIR/_codex") 2>/dev/null || true; }
(( $+commands[gitsnip] )) && { (gitsnip completion zsh > "$COMPDIR/_gitsnip") 2>/dev/null || true; }
(( $+commands[llm] )) && { ((_LLM_COMPLETE=zsh_source llm) > "$COMPDIR/_llm") 2>/dev/null || true; }
(( $+commands[neon] )) && { (neon completion > "$COMPDIR/_neon") 2>/dev/null || true; }
(( $+commands[neonctl] )) && { (neonctl completion > "$COMPDIR/_neonctl") 2>/dev/null || true; }
(( $+commands[opencode] )) && { (opencode completion > "$COMPDIR/_opencode") 2>/dev/null || true; }
(( $+commands[ruff] )) && { (ruff generate-shell-completion zsh > "$COMPDIR/_ruff") 2>/dev/null || true; }
(( $+commands[sesh] )) && { (sesh completion zsh > "$COMPDIR/_sesh") 2>/dev/null || true; }
(( $+commands[sops] )) && { (sops completion zsh > "$COMPDIR/_sops") 2>/dev/null || true; }
(( $+commands[talosctl] )) && { (talosctl completion zsh > "$COMPDIR/_talosctl") 2>/dev/null || true; }
(( $+commands[uv] )) && { (uv generate-shell-completion zsh > "$COMPDIR/_uv") 2>/dev/null || true; }
(( $+commands[uvx] )) && { (uvx --generate-shell-completion zsh > "$COMPDIR/_uvx") 2>/dev/null || true; }

if (( $+commands[ollama] )); then
  curl -sS https://gist.githubusercontent.com/obeone/9313811fd61a7cbb843e0001a4434c58/raw/5a6a44efc6a07b6f937dbc596d9d7385b297dda8/_ollama.zsh > "$COMPDIR/_ollama" 2>/dev/null || true
fi

