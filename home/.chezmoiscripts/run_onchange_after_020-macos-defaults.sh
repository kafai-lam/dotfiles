#!/usr/bin/env zsh

echo "Setting up macos preferences with defaults"

# Keyboard and Trackpad Preferences
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.HIToolbox AppleFnUsageType -int 1

# Menubar Preferences
defaults write com.apple.menuextra.clock DateFormat -string "\"EEE d MMM HH:mm:ss\""

# Finder Preferences
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.Finder AppleShowAllFiles -bool true
defaults write com.apple.finder QuitMenuItem -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Screenshot settings
mkdir -p ~/Desktop/Screenshots
defaults write com.apple.screencapture "include-date" -bool "true"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture location -string "$HOME/Desktop/Screenshots"
defaults write com.apple.screencapture type -string "png"

# Dock Preferences
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock springboard-columns -int 8
defaults write com.apple.dock springboard-rows -int 5
defaults write com.apple.dock tilesize -int 48

# Restart
killall SystemUIServer
killall Finder
killall Dock
