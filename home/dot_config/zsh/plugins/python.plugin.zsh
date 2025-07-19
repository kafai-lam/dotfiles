#!/usr/bin/env zsh

(( $+commands[pip] )) && alias pip="noglob pip"
(( $+commands[poetry] )) && alias poetry="noglob poetry"
(( $+commands[python] )) && alias py="python"
(( $+commands[uv] )) && alias uv="noglob uv"
(( $+commands[llm] )) && eval "$(_LLM_COMPLETE=zsh_source llm)"

# Find python file
alias pyfind='find . -name "*.py"'
alias pygrep='grep -nr --include="*.py"'
alias pyserver="python3 -m http.server"

# Remove python compiled byte-code and mypy/pytest cache in either the current
# directory or in a list of specified directories (including sub directories).
function pyclean() {
  find "${@:-.}" -type f -name "*.py[co]" -delete
  find "${@:-.}" -type d -name "__pycache__" -delete
  find "${@:-.}" -depth -type d -name ".mypy_cache" -exec rm -r "{}" +
  find "${@:-.}" -depth -type d -name ".pytest_cache" -exec rm -r "{}" +
}

## venv settings
: ${PYTHON_VENV_NAME:=.venv}

# Array of possible virtual environment names to look for, in order
# -U for removing duplicates
typeset -gaU PYTHON_VENV_NAMES
[[ -n "$PYTHON_VENV_NAMES" ]] || PYTHON_VENV_NAMES=($PYTHON_VENV_NAME venv .venv)

# Activate a the python virtual environment specified.
# If none specified, use the first existing in $PYTHON_VENV_NAMES.
function vrun() {
  if [[ -z "$1" ]]; then
    local name
    for name in $PYTHON_VENV_NAMES; do
      local venvpath="${name:P}"
      if [[ -d "$venvpath" ]]; then
        vrun "$name"
        return $?
      fi
    done
    echo >&2 "Error: no virtual environment found in current directory"
  fi

  local name="${1:-$PYTHON_VENV_NAME}"
  local venvpath="${name:P}"

  if [[ ! -d "$venvpath" ]]; then
    echo >&2 "Error: no such venv in current directory: $name"
    return 1
  fi

  if [[ ! -f "${venvpath}/bin/activate" ]]; then
    echo >&2 "Error: '${name}' is not a proper virtual environment"
    return 1
  fi

  . "${venvpath}/bin/activate" || return $?
  echo "Activated virtual environment ${name}"
}


# Create a new virtual environment using the specified name.
# If none specified, use $PYTHON_VENV_NAME
function mkv() {
  local name="${1:-$PYTHON_VENV_NAME}"
  local venvpath="${name:P}"

  python3 -m venv "${name}" || return
  echo >&2 "Created venv in '${venvpath}'"
  vrun "${name}"
}
