#!/usr/bin/env bash

# Init script to set up shell and basic shell utilities and a wrapper script for
# other scripts for setting up a host machine. Source folder defaults to
# $HOME/Projects, but works if you clone the project to any folder on the machine.

# Get OS and architecture to do OS specific actions.
OS="$(uname)"
ARC="$(uname -m)"

# This should give us $ID variable with the name of the distro on it.
if [ "$OS" == 'Darwin' ]
then
  # Let's consider macOS major version comparable to Linux distro.
  # Manually set the codename from the version number starting from sierra.
  VER="$(sw_vers -productVersion)"
  if [[ $VER == 10.12* ]]
  then
    DISTRO='sierra'
  else
    DISTRO='unknow'
  fi
elif [ "$OS" == 'Linux' ]
then
  source /etc/os-release
  DISTRO=$ID
else
  DISTRO='unknow'
fi

# @TODO: Maybe change the shell of all users on the system for a consistent workflow?
# @TODO: Maybe setup the global zshrc at /etc/zsh/zshrc? See more info https://wiki.archlinux.org/index.php/zsh and https://github.com/robbyrussell/oh-my-zsh#advanced-installation

# Initialize the array of utilities to check for installation.
UTILITIES=()

# Define the utilities to be installed in alphabetical order.
# A package per line so that changes are easy to diff with git.
if [ "$OS" == 'Darwin' ]
# macOS utility requirements.
then
  # These are needed by the setup.
  # TODO: This installs multiple executables which of none are called coreutils so it always tries to install this.
  UTILITIES+=('coreutils')
  # TODO: This installs an executable called node so it always tries to install this.
  UTILITIES+=('nodejs') # Include npm.
  # These are just for convenience.
  UTILITIES+=('screen')
  UTILITIES+=('wget')
elif [ "$OS" == 'Linux' ]
# Linux utility requirements.
then
  # These are needed by the setup.
  UTILITIES+=('git')
  UTILITIES+=('nodejs')
  UTILITIES+=('npm')
  UTILITIES+=('zsh')
  # These are just for convenience.
  UTILITIES+=('screen')
  UTILITIES+=('unzip')
  UTILITIES+=('wget')
  # Distro specific needs.
  if [ "$DISTRO" == 'fedora' ]
  then
    UTILITIES+=('util-linux-user')
  fi
fi

# Initialize the array of utilities to install.
INSTALL=()
# Test wether the utilities are already installed and drop the ones that are.
for UTILITY in ${UTILITIES[@]}
do
  if ! hash $UTILITY 2>/dev/null
  then
    INSTALL+=($UTILITY)
  fi
done

# @TODO: Add a check here to not run the install if there is nothing to install.

# Utility installation on macOS.
if [ "$OS" == "Darwin" ]
then
  # First install Homebrew if it's not found. We'll use brew to install other utilities on macOS.
  if ! hash brew 2>/dev/null
  then
    # We will assume that the this script is run either privileged or interactive.
    # In either case the default Homebrew installation script that uses sudo will work.
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  # Install the required utilities with brew.
  brew update
  brew upgrade -y
  brew install -y ${INSTALL[*]}

# Utility installation on Linux. Includes system update where needed.
elif [ "$OS" == "Linux" ]
then
  # Install packages with the package manager that is available.
  if hash pacman 2>/dev/null
  then
    sudo pacman -Syy --noconfirm
    sudo pacman -S ${INSTALL[*]} --noconfirm
  elif hash dnf 2>/dev/null
  then
    sudo dnf clean all && sudo dnf makecache timer
    sudo dnf -y install ${INSTALL[*]}
  elif hash yum 2>/dev/null
  then
    sudo yum clean all && sudo yum makecache fast
    sudo yum -y install ${INSTALL[*]}
  elif hash apt-get 2>/dev/null
  then
    sudo apt-get update
    sudo apt-get --assume-yes install ${INSTALL[*]}
  else
    printf "None of predefined package managers (pacman, dnf, yum or apt-get) found. Aborting...\n"
    exit 1
  fi
fi

# Configure git.
git config --global user.name "Aleksi Johansson"
git config --global user.email "aleksi@aleksijohansson.net"
# Use Keychain on macOS to store git credentials.
if [ "$OS" == 'Darwin' ]
then
  git config --global credential.helper osxkeychain
fi

# Change shell to zsh and install oh-my-zsh.
if hash zsh 2>/dev/null
then
  # Change shell to zsh, only if needed.
  if [[ $SHELL != *zsh ]]
  then
    sudo chsh -s /bin/zsh $USER
  fi
  # Install oh-my-zsh.
  if [ ! -d "$HOME/.oh-my-zsh" ]
  then
    printf "Installing oh-my-zsh...\n"
    git clone https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"
  fi
else
  printf "Shell zsh required, but not installed. Aborting...\n"
  exit 1
fi

# Prepare SSH for configuration.
# Make sure the `controlmasters` folder exists.
mkdir -p ~/.ssh/controlmasters

# Get the enclosing folder of our script.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set the default installation folder for automated installations like vagrant testing and cloud-init
# and make sure the folder exists.
SOURCE="$HOME/Projects"
if [ ! -d $SOURCE ]
then
  mkdir -p $SOURCE
fi

# Get the whole project if we don't have it. This is the case when provisioning with cloud-init and when testing with vagrant.
if [ ! -d "$DIR/dotfiles" ]
then
  printf "Getting the source...\n"
  DIR="$SOURCE/host-setup"
  git clone https://github.com/aleksijohansson/host-setup.git $DIR
fi

# Run different scripts wether the host has GUI or not.
if [ -z ${1+x} ]
then
  # No argument given, so run the default case without GUI.
  printf "Running the host-setup for a host without a GUI. Please give environment 'gui' as an argument to the script if you want to run additional GUI app setup.\n"
  # Run a collection of scripts for non-GUI host.
  source "$DIR/dotfiles.sh"

elif [ "$1" == 'gui' ]
then
  # Run also app-install.sh for GUI host.
  printf "Running the host-setup for a host with a GUI.\n"
  # Run a collection of scripts for non-GUI host.
  source "$DIR/dotfiles.sh"
  source "$DIR/gui-app-install.sh"

else
  # If argument is unknow, only alert the user.
  printf "Unknown argument. Run the script without arguments or with 'gui' argument if you want to setup a host with GUI.\n"
fi
