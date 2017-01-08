#!/usr/bin/env bash

# Supports only macOS and Arch Linux for now, because they are my choise of desktop (laptop) environments.
# This script can also be run independently without special requirements.

# Get OS and architecture to do OS specific actions.
OS="$(uname)"
ARC="$(uname -m)"

# Commonly used apps to install.
# Arrays of package names defined per distribution/operating system because they may differ.
# First we define the arrays as separate arrays because bash doesn't support multidimensional arrays (arrays inside arrays).
macos=()
macos_casks=()
arch=()

# List of macOS packages to install with Homebrew in alphabetical order.
# A package per line so that changes are easy to diff with git.
macos+=('ansible')
macos+=('vagrant')
# Homebrew casks separated to their own list.
macos_casks+=('insomnia')
macos_casks+=('sequel-pro')
macos_casks+=('tuxera-ntfs')
macos_casks+=('vlc')

# List of Arch Linux packages to install including packages from AUR in alphabetical order.
# A package per line so that changes are easy to diff with git.
arch+=('ansible')
arch+=('insomnia')
arch+=('vagrant')
arch+=('vlc')

# Test of the arrays.
printf "List of macOS apps to install: ${macos[*]}\n"
printf "List of Arch Linux apps to install: ${arch[*]}\n"
