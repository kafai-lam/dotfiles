if (( ! $+commands[aichat] )); then
  return
fi

_aichat_zsh() {
  [[ -z "$BUFFER" ]] && return

  local _old=$BUFFER

  zle -I
  zle redisplay

  local _out
  _out=$(gum spin --title "convert..." -- aichat --execute "$_old")

  BUFFER=$_out
  zle end-of-line
}
zle -N _aichat_zsh

z4h bindkey _aichat_zsh "Option+\\"
