#!/usr/bin/env bash

# Script to setup shared consistent shell and shell utility configuration.
# Supports all operating systems defined in the project documentation.
# Requirements for independent use:
# - ./dotfiles folder relative to the script including the dotfiles you want to setup.
# - Use argument 'gui' to setup also GUI app configs.

# Get OS and architecture to do OS specific actions.
OS="$(uname)"
ARC="$(uname -m)"

# Get the enclosing folder of our script.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set the actual dotfiles folder here so that it can be easily changed.
DOTFILES_DIR="dotfiles"

# Exclude certain dotfiles on based on $OS and 'gui' argument.
EXCLUDES=()
if [ "$OS" == 'Darwin' ]
then
  EXCLUDES=() # No excludes on Darwin at the moment.
elif [ "$OS" == 'Linux' ]
then
  EXCLUDES+=('Library') # Exclude the Library folder and anything on it.
fi
if [ "$1" != 'gui' ]
then
  EXCLUDES+=('.hyper.js') # Hyper is GUI only, exclude the config.
fi

# Dotfile handler function.
link_dotfile() {
  FILENAME="$( realpath --relative-to="$DIR/$DOTFILES_DIR" $1 )"

  # Only remove if excluded.
  REMOVE=false
  # Check exclude lists and return if the file should be excluded.
  for EXCLUDE in ${EXCLUDES[@]}
  do
    # Check if filename starts with the excluded file or folder.
    if [[ $FILENAME == $EXCLUDE* ]]
    then
      printf "Dotfile $FILENAME excluded on $OS.\n"
      REMOVE=true
    fi
  done

  # Set the dotfile path. They all live in the $HOME folder of current user.
  DOTFILE="$HOME/$FILENAME"

  # Backup any existing dotfiles and only if they are files, not symlinks.
  if [ -f $DOTFILE ] && [ ! -L $DOTFILE ]
  then
    printf "Existing dotfile ($DOTFILE) found, backing up... "
    mv $DOTFILE ${DOTFILE}_bak
    printf "done.\n"
  fi
  # Symlink the dotfile into place.
  if [ -f $1 ] && [ $REMOVE != true ]
  then
    printf "Linking dotfile:\n"
    ln -svf "$1" $DOTFILE
  elif [ -f $1 ] && [ $REMOVE == true ]
  then
    printf "Removing excluded dotfile $DOTFILE.\n"
    rm $DOTFILE
  elif [ -d $1 ]
  # If we have a folder instead make sure it exists.
  then
    mkdir -pv $DOTFILE
  fi
}

# Function to iterate over files and go all out inception for folders.
iterate_dotfiles() {
  for ITEM in $1/*
  do
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
iterate_dotfiles "$DIR/$DOTFILES_DIR"

# Change bash dot handling back to the way it was.
shopt -u dotglob
