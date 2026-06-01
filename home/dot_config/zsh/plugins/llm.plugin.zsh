_llm_zsh() {
  [[ -z "$BUFFER" ]] && return

  local _old=$BUFFER
  local _system_prompt="Convert the user's request into a shell command. Output only the command, without Markdown fences, explanations, or surrounding quotes."
  local -a _llm_args=(--no-stream --system "$_system_prompt")
  [[ -n "$LLM_CMD_MODEL" ]] && _llm_args+=(--model "$LLM_CMD_MODEL")

  zle -I
  zle redisplay

  local _out
  if (( $+commands[gum] )); then
    _out=$(printf "%s" "$_old" | gum spin --title "convert..." -- llm "${_llm_args[@]}")
  else
    _out=$(printf "%s" "$_old" | llm "${_llm_args[@]}")
  fi

  [[ -z "$_out" ]] && return

  BUFFER=$_out
  zle end-of-line
}
zle -N _llm_zsh

z4h bindkey _llm_zsh "Option+\\"
