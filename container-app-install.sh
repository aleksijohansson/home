#!/usr/bin/env bash

# Containerized apps from the apps folder of this project.
# @TODO: Fix this. Currently not up to date or usable.

# @TODO: Using sudo here which makes the tests fail. Fix it.
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
