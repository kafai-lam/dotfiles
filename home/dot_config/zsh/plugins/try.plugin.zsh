if (( ! $+commands[try-rs] )); then return; fi

export TRY_CONFIG_DIR="$XDG_CONFIG_HOME/try"
export TRY_PATH="$HOME/Developer/tries"

z4h source $TRY_CONFIG_DIR/try-rs.zsh

