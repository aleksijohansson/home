#!/bin/bash

# Install zsh if it's not available.
if hash wget 2>/dev/null
then
  printf 'We have zsh!\n'
else
  # Install zsh.
  echo 'Installing zsh...'
fi

# Install oh-my-zsh. Use wget or curl if no wget is available.
if hash wget 2>/dev/null
then
  # sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
elseif hash curl 2>/dev/null
  # sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
  printf 'curl or wget required for setup. Aborting...\n'
fi

# Get the Polarized theme for iTerm on OS X.
if [ $(uname) = 'Darwin' ]
then
  # We can expect OS X to have curl available.
  # curl -o ~/Downloads/Solarized%20Dark.itermcolors https://github.com/altercation/ethanschoonover.com/raw/master/projects/solarized/iterm2-colors-solarized/Solarized%20Dark.itermcolors
  printf 'Note: iTerm theme downloaded to "~/Downloads/Solarized Dark.itermcolors", please import it manually in iTerm.\n'
fi
