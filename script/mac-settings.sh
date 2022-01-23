#!/bin/bash

# https://github.com/mathiasbynens/dotfiles/blob/master/.macos

##############################################################################
# General UI/UX
##############################################################################

# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2


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
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write 'Apple Global Domain' com.apple.mouse.tapBehavior 1

# Swipe down with three/four fingers
defaults write com.apple.dock showAppExposeGestureEnabled -bool true


##############################################################################
# Dock
##############################################################################

# Don't show recent application in Dock
defaults write com.apple.dock show-recents -bool false

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

killall Dock


##############################################################################
# Launchpad
##############################################################################

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Grouping windows by application in Mission Control
defaults write com.apple.dock expose-group-by-app -bool true


##############################################################################
# Finder
##############################################################################

# Do not show the file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool false

# Do not show hidden files by default
defaults write com.apple.finder AppleShowAllFiles FALSE

# Show status & path bar
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show the ~/Library folder
chflags nohidden ~/Library

# Warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool true

killall Finder


##############################################################################
# Safari
##############################################################################

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true


##############################################################################
# App Store
##############################################################################

# Automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
