#!/usr/bin/env zsh

echo "Setting up macos preferences with defaults"

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.HIToolbox AppleFnUsageType -int 1

defaults write com.apple.menuextra.clock DateFormat -string "\"EEE d MMM HH:mm:ss\""

defaults write com.apple.screencapture location -string "~/Pictures"
killall SystemUIServer

defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.Finder AppleShowAllFiles -bool true
defaults write com.apple.finder QuitMenuItem -bool true
killall Finder

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock springboard-columns -int 8
defaults write com.apple.dock springboard-rows -int 5
defaults write com.apple.dock tilesize -int 48
killall Dock
