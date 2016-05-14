#!/bin/bash

# Run additional install scripts first.
./zsh_setup.sh

# Only continue if previous steps
if [ "$?" = "0" ]
then
  printf "Installing the dotfiles...\n"
  # Symlink dotfiles.
  # ln -f zshrc ~/.zshrc
  printf "Done.\n"
fi
