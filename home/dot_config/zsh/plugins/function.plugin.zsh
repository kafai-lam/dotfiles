(( $+commands[claude-squad] )) && eval "$(claude-squad completion zsh)"
(( $+commands[codex] )) && eval "$(codex completion zsh)"
(( $+commands[llm] )) && eval "$(_LLM_COMPLETE=zsh_source llm)"
(( $+commands[uv] )) && eval "$(uv generate-shell-completion zsh)"
