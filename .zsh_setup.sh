#!/bin/bash

# Abort if we don't have zsh installed.
if hash zsh 2>/dev/null
then
  # Install oh-my-zsh. Use wget or curl if no wget is available.
  if hash wget 2>/dev/null
  then
    printf "Installing oh-my-zsh...\n"
    # sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
  elif hash curl 2>/dev/null
  then
    printf "Installing oh-my-zsh...\n"
    # sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  else
    printf "curl or wget required for zsh setup. Aborting...\n"
    exit 1
  fi

  # Get Powerline theme for oh-my-zsh
  printf "Downloading Powerline theme for oh-my-zsh...\n"
  cd ~/ && git clone git@github.com:jeremyFreeAgent/oh-my-zsh-powerline-theme.git && cd oh-my-zsh-powerline-theme && ./install_in_omz.sh

  # Get the Polarized theme for iTerm on OS X.
  if [ "$(uname)" = "Darwin" ]
  then
    printf "Downloading Solarized Dark theme for iTerm...\n"
    # We can expect OS X to have curl available.
    # curl -o ~/Downloads/Solarized%20Dark.itermcolors https://github.com/altercation/ethanschoonover.com/raw/master/projects/solarized/iterm2-colors-solarized/Solarized%20Dark.itermcolors
    printf "Note: iTerm theme downloaded to '~/Downloads/Solarized Dark.itermcolors', please import it manually in iTerm.\n"
  fi
else
  printf "zsh required. Aborting... \n"
  exit 1
fi
