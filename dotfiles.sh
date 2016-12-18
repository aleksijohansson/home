#!/usr/bin/env bash

# Script to setup shared consistent shell and shell utility configuration.
# Supports all operating systems defined in the project documentation.
# Requirements for independent use:
# - ./dotfiles folder relative to the script including the dotfiles you want to setup

# Get OS and architecture to do OS specific actions.
OS="$(uname)"
ARC="$(uname -m)"

# Get the enclosing folder of our script.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Dotfile handler function.
link_dotfile() {
  IFS='/' read -r -a DOTFILES <<< "$1"
  for i in "${DOTFILES[@]}"
  do
    # FILENAME gets overridden for each item and settle for the last one which is our filename.
    FILENAME=$i
  done

  # @DEBUG
  printf "Filename is: $FILENAME\n"

  # Set the dotfile path. They all live in the $HOME folder of current user.
  DOTFILE="$HOME/$FILENAME"

  # Backup any existing dotfiles and only if they are files, not symlinks.
  if [ -f $DOTFILE ] && [ ! -L $DOTFILE ]
  then
    printf "Existing dot file ($DOTFILE) found, backing up...\n"
    mv $DOTFILE ${DOTFILE}_bak
  fi
  # Symlink the dotfile into place.
  if [ -f $1 ]
  then
    printf "Installing dot file ($DOTFILE)...\n"
    ln -vsf "$1" $DOTFILE
  elif [ -d $1 ]
  # If we have a folder instead make sure it exists.
  then
    mkdir -p "$1"
  fi
}
# Function to iterate over files and go all out inception for folders.
# @TODO: Maybe separate desktop (like Hyper's .hyper.js) and server software here somehow.
iterate_dotfiles() {
  for ITEM in $1/*
  do
    # @DEBUG
    printf "Item is: $ITEM\n"
    if [ -f $ITEM ]
    # Link files.
    then
      link_dotfile $ITEM
    elif [ -d $ITEM ]
    # Process folders further.
    then
      link_dotfile $ITEM # This will make sure the folder exists.
      iterate_dotfiles "$ITEM"
    fi
  done
}

# Change bash dot handling so that using * includes hidden files.
shopt -s dotglob

# Iterate over files in the dotfile folder.
iterate_dotfiles "$DIR/dotfiles"

# Change bash dot handling back to the way it was.
shopt -u dotglob
