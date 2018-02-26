#!/usr/bin/env bash

# Script to setup shared consistent shell and shell utility configuration.
# Supports all operating systems defined in the project documentation.
# Requirements for independent use:
# - ./dotfiles_config.sh relative to the script for config.
# - Use argument 'gui' to setup also GUI app configs.

# Get OS and architecture to do OS specific actions.
OS=`uname`
ARC=`uname -m`

# Get the enclosing folder of our script.
DIR=`cd $( dirname "${BASH_SOURCE[0]}" ) && pwd`

# Get the config.
. "$DIR/dotfiles_config.sh"

# Dotfile handler function.
link_dotfile() {
  FILENAME=`realpath --relative-to="$DIR/$DOTFILES_DIR" "$1"`

  # Only remove if excluded.
  EXCLUDE=false
  # Check exclude lists and return if the file should be excluded.
  for EXC in ${EXCLUDES[@]}
  do
    # Check if filename starts with the excluded file or folder.
    if [[ "$FILENAME" == $EXC* ]]
    then
      printf "Dotfile $FILENAME excluded because of operating system $OS or because no 'gui' was given as argument.\n"
      EXCLUDE=true
    fi
  done

  # Set the dotfile path. They all live in the $HOME folder of current user.
  DOTFILE="$HOME/$FILENAME"

  # Backup any existing dotfiles and only if they are files, not symlinks.
  if [ -f "$DOTFILE" ] && [ ! -L "$DOTFILE" ]
  then
    printf "Existing dotfile ($DOTFILE) found, backing up... "
    mv "$DOTFILE" "${DOTFILE}_bak"
    printf "done.\n"
  fi
  # Symlink the dotfile into place.
  if [ -f "$1" ] && [ $EXCLUDE != true ]
  then
    printf "Linking dotfile:\n"
    ln -svf "$1" "$DOTFILE"
  elif [ -d "$1" ] && [ $EXCLUDE != true ]
  # If we have a folder instead make sure it exists.
  then
    mkdir -pv "$DOTFILE"
  elif [ -L "$DOTFILE" ] && [ $EXCLUDE == true ]
  then
    printf "Removing excluded dotfile $DOTFILE.\n"
    rm "$DOTFILE"
  fi
}

# Function to iterate over files and go all out inception for folders.
iterate_dotfiles() {
  for ITEM in "$1"/*
  do
    if [ -f "$ITEM" ]
    # Link files.
    then
      link_dotfile "$ITEM"
    elif [ -d "$ITEM" ]
    # Process folders further.
    then
      link_dotfile "$ITEM" # This will make sure the folder exists.
      iterate_dotfiles "$ITEM"
    fi
  done
}

# Function to iterate over local only files and generate them.
localonly_dotfiles() {
  for ITEM in "${LOCALONLY[@]}"
  do
    # Only generate files that don't exist.
    if [ ! -f "$HOME/$ITEM" ]
    then
      # Generate the file and ask for content.
      read -p "Generating $ITEM, what should it be? " INPUT
      echo "$INPUT" > "$HOME/$ITEM"
    fi
  done
}

# Change bash dot handling so that using * includes hidden files.
shopt -s dotglob

# Iterate over files in the dotfile folder.
iterate_dotfiles "$DIR/$DOTFILES_DIR"

# Change bash dot handling back to the way it was.
shopt -u dotglob

# Generate the local only files and ask for their content.
localonly_dotfiles
