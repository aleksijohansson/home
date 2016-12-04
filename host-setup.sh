#!/bin/bash

# Get OS and architecture to do OS specific actions.
OS="$(uname)"
ARC="$(uname -m)"

# Get the location of our script.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set the installation folder for automated installations like vagrant testing and cloud-config.
SOURCE="~/Projects"

# TODO: Maybe change the shell of all users on the system for a consistent workflow?
# TODO: Maybe setup the global zshrc at /etc/zsh/zshrc? See more info https://wiki.archlinux.org/index.php/zsh and https://github.com/robbyrussell/oh-my-zsh#advanced-installation

## HOMEBREW

# We will assume that if this is run on OS X, it's interactive.
if [ $OS = "Darwin" ]
then
  if hash brew 2>/dev/null
  then
    printf "Homebrew found. No need to install.\n"
  else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
fi

## GIT

# Testing machines don't have git, so install it if it's not there.
if hash git 2>/dev/null
then
  GIT=""
else
  GIT="git"
fi

## UNZIP

# We can assume we have unzip on OS X.
if [ $OS = "Linux" ]
then
  if hash unzip 2>/dev/null
  then
    UNZIP=""
  else
    UNZIP="unzip"
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
  if hash wget 2>/dev/null
  then
    printf "wget found. No need to install.\n"
  else
    brew install -y wget
  fi
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

  # First check if we have anything to install.
  if [ -n "$WGET" ] || [ -n "$GIT" ] || [ -n "$ZSH" ] || [ -n "$UNZIP" ]
  then
    # Install packages with the package manager that is available.
    if hash pacman 2>/dev/null
    then
      sudo pacman -S $WGET $GIT $ZSH $UNZIP --noconfirm
    elif hash dnf 2>/dev/null
    then
      sudo dnf clean all && sudo dnf makecache timer
      sudo dnf -y install $WGET $GIT $ZSH $UNZIP
    elif hash yum 2>/dev/null
    then
      sudo yum clean all && sudo yum makecache fast
      sudo yum -y install $WGET $GIT $ZSH $UNZIP
    elif hash apt-get 2>/dev/null
    then
      sudo apt-get --assume-yes install $WGET $GIT $ZSH $UNZIP
    else
      printf "None of predefined package managers found. Aborting...\n"
      exit 1
    fi
  fi

fi

## SHELL

# Abort if we don't have zsh installed.
if hash zsh 2>/dev/null
then
  # Change shell to zsh.
  sudo chsh -s /bin/zsh $USER
  # Install oh-my-zsh.
  if [ ! -d "$HOME/.oh-my-zsh" ]
  then
    printf "Installing oh-my-zsh...\n"
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  fi
else
  printf "zsh required, but not installed. Aborting...\n"
  exit 1
fi

## GIT

# Configure git.
git config --global user.name "Aleksi Johansson"
git config --global user.email "aleksi@aleksijohansson.net"
if [ $OS = "Darwin" ]
then
  git config --global credential.helper osxkeychain
fi

## DOTFILES

# Install dotfiles.
printf "Installing the dotfiles...\n"

# Get dotfiles if we don't have them. This is the case when provisioning with cloud-config and when testing with vagrant.
if [ ! -d "$DIR/dotfiles" ]
then
  printf "Getting the source...\n"
  DIR="$SOURCE/host-setup"
  git clone https://github.com/aleksijohansson/host-setup.git "$DIR"
  # Change the working directory to the project folder.
  cd "$DIR"
fi

# Handle each dotfile individually.
for FILE in $DIR/dotfiles/*
do

  # Make sure we actually have a file to work with.
  if [ -f $FILE ]
  then

    IFS='/' read -r -a DOTFILES <<< "$FILE"
    for i in "${DOTFILES[@]}"
    do
      # FILENAME gets overridden for each item and settle for the last one which is our filename.
      FILENAME=$i
    done

    # Format the dotfile.
    DOTFILE=~/.$FILENAME

    # Backup any existing dotfiles.
    if [ -f $DOTFILE ] && [ ! -L $DOTFILE ]
    then
      printf "Existing dot file ($DOTFILE) found, backing up...\n"
      mv $DOTFILE ${DOTFILE}_bak
    fi
    # Symlink the dotfile into place.
    printf "Installing dot file ($DOTFILE)...\n"
    ln -vsf $FILE $DOTFILE

  fi

done

## SSH config.
# TODO: Change this to work more generally in the above for loop.
printf "Installing SSH config...\n"
ln -vsf "$DIR/dotfiles/ssh/config" ~/.ssh/config

# Handle each app individually.
# TODO: Using sudo here which makes the tests fail. Fix it.
for FILE in $DIR/apps/*
do

  # Make sure we actually have a file to work with.
  if [ -f $FILE ]
  then

    IFS='/' read -r -a APPS <<< "$FILE"
    for i in "${APPS[@]}"
    do
      # FILENAME gets overridden for each item and settle for the last one which is our filename.
      FILENAME=$i
    done

    # Format the app.
    APP=/usr/local/bin/$FILENAME

    # Backup any existing app files.
    if [ -f $APP ] && [ ! -L $APP ]
    then
      printf "Existing app file ($APP) found, backing up...\n"
      sudo mv $APP ${APP}_bak
    fi
    # Symlink the app files into place.
    printf "Installing app file ($APP)...\n"
    sudo ln -vsf $FILE $APP

  fi

done


printf "Done.\n"
