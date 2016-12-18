#!/usr/bin/env bash

# Supports only macOS and Arch Linux for now, because they are my choise of desktop (laptop) environments.

# Get OS and architecture to do OS specific actions.
OS="$(uname)"
ARC="$(uname -m)"

# Commonly used apps to install.
# Arrays of package names defined per distribution/operating system because they may differ.
# First we define the arrays as separate arrays because bash doesn't support multidimensional arrays (arrays inside arrays).
macos=()
arch=()

# List of macOS packages to install in alphabetical order.
macos+=('ansible')
macos+=('insomnia')

# List of Arch Linux packages to install including packages from AUR in alphabetical order.
arch+=('ansible')
arch+=('insomnia')

# Test of the arrays.
printf "List of macOS apps to install: ${macos[*]}\n"
printf "List of Arch Linux apps to install: ${arch[*]}\n"
