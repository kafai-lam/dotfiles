#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title mac defaults
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Developer Utils

# Documentation:
# @raycast.description setup macos defaults
# @raycast.author Fai
# @raycast.authorURL https://github.com/kafai97

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE d MMM HH:mm:ss\""
defaults write com.apple.screencapture "location" -string "~/Pictures" && killall SystemUIServer

defaults write com.apple.Finder "AppleShowAllFiles" -bool "true"
defaults write com.apple.finder "QuitMenuItem" -bool "true"
killall Finder

defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock "orientation" -string "bottom"
defaults write com.apple.dock "tilesize" -int "48"
defaults write com.apple.dock "mru-spaces" -bool "false"
killall Dock