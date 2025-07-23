if (( ! $+commands[mise] )); then
  return
fi

alias m="mise"
alias mr="mise run"

eval "$(mise activate zsh)"
