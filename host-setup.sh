#!/bin/bash

# Run additional install scripts first.
./zsh-setup.sh

# Only continue if previous steps succeeded.
if [ "$?" = "0" ]
then
  printf "Installing the dotfiles...\n"
  # Symlink dotfiles.
  ln -s $(pwd)/zshrc ~/.zshrc
  printf "Done.\n"
fi
