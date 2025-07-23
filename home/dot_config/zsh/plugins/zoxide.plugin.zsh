if (( ! $+commands[zoxide] )); then
  return
fi

export _ZO_FZF_OPTS="""
--tmux 80%,75% --ansi --tabstop=1 \
--exact --no-sort --cycle --exit-0 \
--border-label ' cd ' --prompt ' '
--bind=ctrl-z:ignore,btab:down,tab:up \
--preview-window=right,55% \
--preview='eza --group-directories-first --icons --all --git --color=always -lh  {2..}'
"""

eval "$(zoxide init zsh --cmd cd)"
