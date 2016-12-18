#!/usr/bin/env bash

# Get OS and architecture to do OS specific actions.
OS="$(uname)"
ARC="$(uname -m)"

# Commonly used apps to install.
# Arrays of package names defined per distribution/operating system because they may differ.
# Identification of distribution is done by package manager which is not explicit, but works for my needs.
# First we define the arrays.
apps=()
apps[macos]=()
apps[arch]=()

# List of macOS packages to install in alphabetical order.
apps[macos]+=('insomnia')

# List of Arch Linux packages to install including packages from AUR in alphabetical order.
apps[arch]+=('insomnia')

# Test of the arrays.
printf "List of macOS apps to install: apps[macos]\n"
printf "List of Arch Linux apps to install: apps[arch]\n"
