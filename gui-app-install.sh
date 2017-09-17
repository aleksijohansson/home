#!/usr/bin/env bash

# Supports only macOS and Arch Linux for now, because they are my choise of desktop (laptop) environments.
# This script can also be run independently without special requirements.

# Get OS and architecture to do OS specific actions.
OS="$(uname)"
ARC="$(uname -m)"

# Commonly used apps to install.
# Arrays of package names defined per distribution/operating system because they may differ.
# First we define the arrays as separate arrays because bash doesn't support multidimensional arrays (arrays inside arrays).
macos_taps=()
macos=()
macos_casks=()
arch=()
arch_pip=()
npm=()
rbenv=()
vagrant=()
macos_pip=()

# List of additional Homebrew taps.
macos_taps+=('drone/drone')
# List of macOS packages to install with Homebrew in alphabetical order.
# A package per line so that changes are easy to diff with git.
macos+=('drone')
macos+=('jq')
macos+=('rbenv')
# Homebrew casks separated to their own list.
macos_casks+=('atom')
macos_casks+=('cleanmymac')
macos_casks+=('gitkraken')
macos_casks+=('google-chrome')
macos_casks+=('harvest')
macos_casks+=('hyper')
macos_casks+=('insomnia')
macos_casks+=('sequel-pro')
macos_casks+=('slack')
macos_casks+=('spectacle')
macos_casks+=('spotify')
macos_casks+=('telegram-desktop')
macos_casks+=('tuxera-ntfs')
macos_casks+=('vagrant')
macos_casks+=('virtualbox')
macos_casks+=('virtualbox-extension-pack')
macos_casks+=('vlc')
macos_casks+=('vyprvpn')
macos_casks+=('vyprvpn')
macos_casks+=('zoomus')

# Some apps are better to install from pip on macOS
macos_pip+=('ansible')
macos_pip+=('dopy')

# Apps to install Mac App Store manually.
# - Amphetamine
# - Gifox
# - iMovie
# - Keynote
# - Numbers
# - Pages
# - Paste (because it was bought there)
# - Xcode

# List of Vagrant plugins to install.
vagrant+=('vagrant-hostmanager')
vagrant+=('vagrant-cachier')

# List of Arch Linux packages to install including packages from AUR in alphabetical order.
# A package per line so that changes are easy to diff with git.
arch+=('ansible')
arch+=('gitkraken')
arch+=('insomnia')
arch+=('jq')
arch+=('rbenv')
arch+=('telegram-desktop-bin')
arch+=('vagrant')
arch+=('vlc')
arch+=('qt4') # For vlc GUI

# Arch stuff from Pip too.
arch_pip+=('dopy')

# List of Ruby versions to install and configure.
rbenv+=('2.4.1')

# List of global npm packages to install with -g flag.
npm+=('gulp-cli')

# Test of the arrays.
printf "List of macOS apps to install: ${macos[*]}\n"
printf "List of macOS gui apps to install: ${macos_casks[*]}\n"
printf "List of Vagrant plugins to install: ${vagrant[*]}\n"
printf "List of Arch Linux apps to install: ${arch[*]}\n"
