#!/bin/bash

# Run additional install scripts first.
./.zsh_setup.sh

# Only continue if previous steps
if [ "$?" = "0" ]
then
  printf "Moving the project...\n"
  # Copy contents to home folder.
  # cp -a . ~/
  # Remove the temporary repository.
  # cd ..
  # rm -rf home
  printf "Done.\n"
fi
