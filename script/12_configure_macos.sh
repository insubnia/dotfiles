#!/bin/bash

# https://github.com/mathiasbynens/dotfiles/blob/master/.macos
# https://github.com/tkareine/dotfiles/blob/master/.macos

##############################################################################
# General UI/UX
##############################################################################

# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2


##############################################################################
# Keyboad / Text
##############################################################################

# Fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 20

# Enable full keyboard access for all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Use smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool true

# Don't use smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disalbe Apple's press & hold only for VSCode
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

##############################################################################
# Trackpad / Mouse
##############################################################################

# Clicking w/o pressing
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write 'Apple Global Domain' com.apple.mouse.tapBehavior 1

# Swipe down with three/four fingers
defaults write com.apple.dock showAppExposeGestureEnabled -bool true


##############################################################################
# Dock / MenuBar
##############################################################################

# Set menubar item spaces
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 12
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 8

# Don't show recent application in Dock
defaults write com.apple.dock show-recents -bool false

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Set <Recent documents, applications, and servers> to 0
osascript << EOF
  tell application "System Events"
    tell appearance preferences
      set recent documents limit to 0
      set recent applications limit to 0
      set recent servers limit to 0
    end tell
  end tell
EOF

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

# Avoid creating .DS_Store files on network and USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

killall Finder


##############################################################################
# Safari
##############################################################################

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

# Enable develop menu
defaults write com.apple.Safari IncludeDevelopMenu -bool true


##############################################################################
# App Store
##############################################################################

# Automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
