#!/bin/bash

# Get OS to do OS specific actions.
OS="$(uname)"
ARC="$(uname -m)"

## HOMEBREW

# We will assume that if this is run on OS X, it's interactive.
if [ $OS = "Darwin" ]
then
  if ! hash brew 2>/dev/null
  then
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
  brew install -y wget
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
    printf "None of predefined package managers found. Aborting..."
    exit 1
  fi

fi

## SHELL

# TODO: Change this so that any font madness is done only if needed:
# - Arch, install with from AUR powerline-fonts-git (or maybe not)
# - On Linux, install with instructions here https://powerline.readthedocs.io/en/latest/installation/linux.html#fonts-installation
# - On OS X, keep what we are doing now.
# TODO: Maybe change back to powerlevel9k and try it in compability mode if it would work without fonts.
# - See https://github.com/bhilburn/powerlevel9k/wiki/Install-Instructions#step-2-install-powerline-fonts
# TODO: Consider actually installing Powerline.
# See http://askubuntu.com/questions/283908/how-can-i-install-and-use-powerline-plugin
# and https://fedoramagazine.org/add-power-terminal-powerline/
# and also http://powerline.readthedocs.io/en/master/installation.html
# and one more for OS X https://blog.codefront.net/2013/10/27/installing-powerline-on-os-x-homebrew/

# Abort if we don't have zsh installed.
if hash zsh 2>/dev/null
then

  # Change shell to zsh.
  sudo chsh -s /bin/zsh $USER

  # Install oh-my-zsh.
  printf "Installing oh-my-zsh...\n"
  sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

  # Get the Droid Sans Mono for Powerline font while we are at it.
  printf "Downloading Droid Sans Mono for Powerline font...\n"
  wget -P ~/ https://github.com/powerline/fonts/raw/master/DroidSansMono/Droid%20Sans%20Mono%20for%20Powerline.otf

  # Prepare oh-my-zsh for custom themes.
  mkdir -p ~/.oh-my-zsh/custom/themes
  # Get Powerline theme for oh-my-zsh.
  printf "Downloading Powerline theme for oh-my-zsh...\n"
  mkdir -p ~/Projects
  git clone https://github.com/jeremyFreeAgent/oh-my-zsh-powerline-theme.git ~/Projects/oh-my-zsh-powerline-theme
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
    wget -P ~/Downloads/ https://github.com/altercation/ethanschoonover.com/raw/master/projects/solarized/iterm2-colors-solarized/Solarized%20Dark.itermcolors
    printf "Note: iTerm theme downloaded to '~/Downloads/Solarized Dark.itermcolors', please import it manually in iTerm.\n"

  fi

else
  printf "zsh required, but not installed. Aborting... \n"
  exit 1
fi

## VAULT

VAULTVER="0.5.2"
VAULTURL="https://releases.hashicorp.com/vault/$VAULTVER/vault_$VAULTVER"

# Get correct vault binary for the OS and architecture of the host.
if [ $OS = "Linux" ]
then

  # We need to use sudo with Linux.
  SUDO="sudo"

  # Modern hosts here only.
  if [ $ARC = "x86_64" ]
  then
    VAULTARC="_linux_amd64"
  # There's only one binary for ARM, let's hope it works.
  elif [[ $ARC == *"arm"* ]]
  then
    VAULTARC="_linux_arm"
  else
    printf "Your Linux architecture is not supported. Aborting...\n"
    exit 1
  fi

elif [ $OS = "Darwin" ]
then
  # On OS X with Homebrew installed we don't need sudo.
  SUDO=""
  # Let's assume only moders OS X is used as host.
  VAULTARC="_darwin_amd64"
else
  printf "Your OS is not supported. Aborting...\n"
  exit 1
fi

printf "Downloading Vault...\n"
wget "$VAULTURL$VAULTARC.zip"
printf "Unzipping Vault...\n"
unzip "vault_$VAULTVER$VAULTARC.zip"
rm "vault_$VAULTVER$VAULTARC.zip"
printf "Installing Vault...\n"
$SUDO mv vault /usr/local/bin/

## DOTFILES

# Install dotfiles.
printf "Installing the dotfiles...\n"

# Get dotfiles if we don't have them. This is the case when provisioning with cloud-confg and when testing with vagrant.
if [ ! -d dotfiles ]
then
  git clone https://github.com/aleksijohansson/host-setup.git ~/Projects/host-setup
  # Change the working directory to the project folder.
  cd ~/Projects/host-setup
fi

# Handle each dotfile individually.
for FILE in $(pwd)/dotfiles/*
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
    if [ -e $DOTFILE ]
    then
      printf "Existing dot file ($DOTFILE) found, backing up...\n"
      mv $DOTFILE ~/.${FILENAME}_bak
    fi
    # Symlink the dotfile into place.
    printf "Installing dot file ($DOTFILE)...\n"
    ln -vs $FILE $DOTFILE

  fi

done

printf "Done.\n"
