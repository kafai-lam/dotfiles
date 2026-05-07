_llm_zsh() {
  [[ -z "$BUFFER" ]] && return

  local _old=$BUFFER
  local _system_prompt="Convert the user's request into a shell command. Output only the command, without Markdown fences, explanations, or surrounding quotes."

  zle -I
  zle redisplay

  local _out
  if (( $+commands[gum] )); then
    _out=$(printf "%s" "$_old" | gum spin --title "convert..." -- llm --no-stream --system "$_system_prompt")
  else
    _out=$(printf "%s" "$_old" | llm --no-stream --system "$_system_prompt")
  fi

  [[ -z "$_out" ]] && return

  BUFFER=$_out
  zle end-of-line
}
zle -N _llm_zsh

z4h bindkey _llm_zsh "Option+\\"
