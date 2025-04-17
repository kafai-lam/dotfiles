#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title toggle function keys
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔧

# Documentation:
# @raycast.description toggle function keys
# @raycast.author kafai-lam
# @raycast.authorURL https://raycast.com/kafai-lam

toggle_function_keys() {
    local current_state=$(defaults read -g com.apple.keyboard.fnState)

    if [ "$current_state" = 0 ]; then
        defaults write -g com.apple.keyboard.fnState -bool true
        echo "Function Keys is Function Key"
    else
        defaults write -g com.apple.keyboard.fnState -bool false
        echo "Fn Keys is System Key"
    fi
}

toggle_function_keys
