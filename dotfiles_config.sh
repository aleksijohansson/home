#!/usr/bin/env bash

# Config for dotfiles.sh.

# The actual dotfiles folder related to the script.
DOTFILES_DIR="dotfiles"

# Exclude certain dotfiles on based on $OS and 'gui' argument.
EXCLUDES=()
if [ "$OS" == 'Darwin' ]
then
  EXCLUDES+=('.ssh/config.d/linux') # Exclude the Linux SSH config file.
elif [ "$OS" == 'Linux' ]
then
  EXCLUDES+=('Library') # Exclude the Library folder and anything on it.
  EXCLUDES+=('.ssh/config.d/macos') # Exclude the macOS SSH config file.
fi
if [ "$1" != 'gui' ]
then
  EXCLUDES+=('.hyper.js') # Hyper is GUI only, exclude the config.
fi

# Local only dotfiles that will be generated on demand and content requested
# from the user.
LOCALONLY=()
LOCALONLY+=('.op-secret')
