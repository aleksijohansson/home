#!/bin/bash

# Abort if we don't have zsh installed.
if hash zsh 2>/dev/null
then
  # Install oh-my-zsh. Use wget or curl if no wget is available.
  if hash wget 2>/dev/null
  then
    printf "Installing oh-my-zsh...\n"
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    # Get the Droid Sans Mono for Powerline font while we are at it.
    printf "Downloading Droid Sans Mono for Powerline font...\n"
    cd ~/ && wget https://github.com/powerline/fonts/raw/master/DroidSansMono/Droid%20Sans%20Mono%20for%20Powerline.otf
  elif hash curl 2>/dev/null
  then
    printf "Installing oh-my-zsh...\n"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    # Get the Droid Sans Mono for Powerline font while we are at it.
    printf "Downloading Droid Sans Mono for Powerline font...\n"
    cd ~/ && curl -o https://github.com/powerline/fonts/raw/master/DroidSansMono/Droid%20Sans%20Mono%20for%20Powerline.otf
  else
    printf "curl or wget required for zsh setup. Aborting...\n"
    exit 1
  fi

  # Prepare oh-my-zsh for custom themes.
  mkdir -p ~/.oh-my-zsh/custom/themes
  # Get Powerline theme for oh-my-zsh.
  printf "Downloading Powerline theme for oh-my-zsh...\n"
  mkdir -p ~/Projects
  git clone git@github.com:jeremyFreeAgent/oh-my-zsh-powerline-theme.git ~/Projects/oh-my-zsh-powerline-theme
  # Install Powerline theme for oh-my-zsh.
  printf "Installing Powerline theme for oh-my-zsh...\n"
  ln -s ~/Projects/oh-my-zsh-powerline-theme/powerline.zsh-theme ~/.oh-my-zsh/custom/themes/powerline.zsh-theme

  # Do OS specific finalisations.
  OS="$(uname)"
  if [ $OS = "Linux" ]
  then
    # Prepare the fonts folder.
    sudo mkdir -p /usr/share/fonts/opentype
    # Move the fonts into place.
    printf "Moving fonts into place...\n"
    sudo mv ~/*.otf /usr/share/fonts/opentype/
    # Update font cache.
    sudo fc-cache -f -v
  elif [ $OS = "Darwin" ]
  then
    # Move the fonts into place.
    printf "Moving fonts into place...\n"
    mv ~/*.otf ~/Library/Fonts/
    printf "Downloading Solarized Dark theme for iTerm...\n"
    # We can expect OS X to have curl available.
    curl -o ~/Downloads/Solarized%20Dark.itermcolors https://github.com/altercation/ethanschoonover.com/raw/master/projects/solarized/iterm2-colors-solarized/Solarized%20Dark.itermcolors
    printf "Note: iTerm theme downloaded to '~/Downloads/Solarized Dark.itermcolors', please import it manually in iTerm.\n"
  fi
else
  printf "zsh required. Aborting... \n"
  exit 1
fi
