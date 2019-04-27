#!/bin/bash

# Tips taken from: https://github.com/mathiasbynens/dotfiles/blob/master/.macos

##############################################################################
# General UI/UX
##############################################################################

# Set sidebar icon size to large
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 3


##############################################################################
# HIDs
##############################################################################

# Fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 20

# Enable full keyboard access for all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Clicking w/o pressing
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

##############################################################################
# Dock
##############################################################################

# Don't show recent application in Dock
defaults write com.apple.dock show-recents -bool false

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true


##############################################################################
# Finder
##############################################################################

# Show status & path bar
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool true


##############################################################################
# Safari
##############################################################################


##############################################################################
# App Store
##############################################################################

# Automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
