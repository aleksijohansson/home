#!/usr/bin/env bash

# Script to setup shared consistent shell and shell utility configuration.
# Supports all operating systems defined in the project documentation.
# Requirements for independent use:
# - ./dotfiles folder relative to the script

# Get OS and architecture to do OS specific actions.
OS="$(uname)"
ARC="$(uname -m)"

# Get the enclosing folder of our script.
# @TODO: How does this work, if this script is started from another script?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# @DEBUG
printf "dotfiles.sh script DIR=$DIR\n"

# Dotfile handler function.
link_dotfile() {
  IFS='/' read -r -a DOTFILES <<< "$1"
  for i in "${DOTFILES[@]}"
  do
    # FILENAME gets overridden for each item and settle for the last one which is our filename.
    FILENAME=$i
  done

  # Set the dotfile path. They all live in the home folder of current user.
  DOTFILE="$HOME/$FILENAME"

  # Backup any existing dotfiles and only if they are files, not symlinks.
  if [ -f $DOTFILE ] && [ ! -L $DOTFILE ]
  then
    printf "Existing dot file ($DOTFILE) found, backing up...\n"
    mv $DOTFILE ${DOTFILE}_bak
  fi
  # Symlink the dotfile into place.
  printf "Installing dot file ($DOTFILE)...\n"
  ln -vsf $1 $DOTFILE
}

# Iterate over files in the dotfile folder.
# @TODO: Maybe separate desktop (like Hyper's .hyper.js) and server software here somehow.
for FILE in $DIR/dotfiles/*
do

  # Make sure we actually have a file to work with.
  if [ -f $FILE ]
  then

    link_dotfile $FILE

  elif [ -d $FILE ]
  then



  fi

done
