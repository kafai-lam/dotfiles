#!/usr/bin/env zsh

if (( ! $+commands[eza] )); then
  return
fi

# Create alias override commands using 'eza'
alias ls='eza --group-directories-first --icons -a'

# Use the --git flag if the installed version of exa supports git
# Related to https://github.com/ogham/exa/issues/978
if eza --version | grep -q '+git'; then
  alias ll='ls -lh --git'
else
  alias ll='ls -lh'
fi

alias la='ll -a'
alias tree='ll --tree -I .git --git-ignore'
