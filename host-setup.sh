#!/bin/bash

# Get OS to do OS specific actions.
OS="$(uname)"

## HOMEBREW

# We will assume that if this is run on OS X, it's interactive.
if [ $OS = "Darwin" ]
then
  if hash brew 2>/dev/null
  then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
fi

## WGET

# Let's make sure we have wget before we start.
if [ $OS = "Linux" ]
then

  # On Linux, save installation for later.
  if hash wget 2>/dev/null
  then
    WGET=""
  else
    WGET="wget"
  fi

elif [ $OS = "Darwin" ]
then

  # Install wget straigt up with brew.
  brew install -y wget

fi

## GIT

# Testing machines don't have git, so install it if it's not there.
if hash git 2>/dev/null
then
  GIT=""
else
  GIT="git"
fi

## ZSH

# OS X comes with zsh, but most Linux distributions don't.
if [ $OS = "Linux" ]
then

  if hash zsh 2>/dev/null
  then
    ZSH=""
  else
    ZSH="zsh"
  fi

fi

# Do actual install on Linux.

if [ $OS = "Linux" ]
then

  # Install packages with the package manager that is available.
  if hash pacman 2>/dev/null
  then
    sudo pacman -S $WGET $GIT $ZSH --noconfirm
  elif hash dnf 2>/dev/null
  then
    sudo dnf clean all && sudo dnf makecache timer
    sudo dnf -y install $WGET $GIT $ZSH
  elif hash yum 2>/dev/null
  then
    sudo yum clean all && sudo yum makecache fast
    sudo yum -y install $WGET $GIT $ZSH
  elif hash apt-get 2>/dev/null
  then
    sudo apt-get --assume-yes install $WGET $GIT $ZSH
  else
    printf "None of predefined package managers found. Aborting..."
    exit 1
  fi

fi

## SHELL

# Abort if we don't have zsh installed.
if hash zsh 2>/dev/null
then

  # Change shell to zsh without prompt.
  # TODO: Implement this.

  # Install oh-my-zsh.
  printf "Installing oh-my-zsh...\n"
  sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
  # Get the Droid Sans Mono for Powerline font while we are at it.
  printf "Downloading Droid Sans Mono for Powerline font...\n"
  cd ~/ && wget https://github.com/powerline/fonts/raw/master/DroidSansMono/Droid%20Sans%20Mono%20for%20Powerline.otf

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
    wget ~/Downloads/Solarized%20Dark.itermcolors https://github.com/altercation/ethanschoonover.com/raw/master/projects/solarized/iterm2-colors-solarized/Solarized%20Dark.itermcolors
    printf "Note: iTerm theme downloaded to '~/Downloads/Solarized Dark.itermcolors', please import it manually in iTerm.\n"

  fi

else

  printf "zsh required, but not installed. Aborting... \n"
  exit 1

fi

## DOTFILES

# Install dotfiles.
printf "Installing the dotfiles...\n"
# Symlink dotfiles.
ln -s $(pwd)/dotfiles/zshrc ~/.zshrc
printf "Done.\n"
