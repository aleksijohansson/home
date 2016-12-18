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

  # Set the dotfile path. They all live in the $HOME folder of current user.
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

# Change bash dot handling so that using * includes hidden files.
shopt -s dotglob
# Iterate over files in the dotfile folder.
# @TODO: Maybe separate desktop (like Hyper's .hyper.js) and server software here somehow.
for FILE in "$DIR/dotfiles/*"
do

  # Make sure we actually have a file to work with.
  if [ -f "$FILE" ]
  then

    link_dotfile $FILE

  elif [ -d "$FILE" ]
  then

    printf "Work in progress."

  fi

done

# Change bash dot handling back to the way it was.
shopt -u dotglob
