try-rs() {
    # Pass flags/options directly to stdout without capturing
    for arg in "$@"; do
        case "$arg" in
            -*) command try-rs "$@"; return ;;
        esac
    done

    # Captures the output of the binary (stdout) which is the "cd" command
    # The TUI is rendered on stderr, so it doesn't interfere.
    local output
    output=$(command try-rs "$@")

    if [ -n "$output" ]; then
        eval "$output"
    fi
}

# try-rs tab completion for directory names
_try_rs_get_tries_path() {
    # Check TRY_PATH environment variable first
    if [[ -n "${TRY_PATH}" ]]; then
        echo "${TRY_PATH}"
        return
    fi

    # Try to read from config file
    local config_paths=("$HOME/.config/try-rs/config.toml" "$HOME/.try-rs/config.toml")
    for config_path in "${config_paths[@]}"; do
        if [[ -f "$config_path" ]]; then
            local tries_path=$(grep -E '^\s*tries_path\s*=' "$config_path" 2>/dev/null | sed 's/.*=\s*"\?\([^"]*\)"\?.*/\1/' | sed "s|~|$HOME|" | tr -d '[:space:]')
            if [[ -n "$tries_path" ]]; then
                echo "$tries_path"
                return
            fi
        fi
    done

    # Default path
    echo "$HOME/work/tries"
}

_try_rs_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local tries_path=$(_try_rs_get_tries_path)
    local -a dirs=()

    if [[ -d "$tries_path" ]]; then
        # Get list of directories
        while IFS= read -r dir; do
            dirs+=("$dir")
        done < <(ls -1 "$tries_path" 2>/dev/null | while read -r dir; do
            if [[ -d "$tries_path/$dir" ]]; then
                echo "$dir"
            fi
        done)
    fi

    COMPREPLY=($(compgen -W "${dirs[*]}" -- "$cur"))
}

complete -o default -F _try_rs_complete try-rs
