#!/bin/sh

# Get the OS for later use
OS="$(uname)"

# Mount local configuration files based on OS
if [ $OS = "Linux" ]
then
  docker run --rm -ti \
  --env=SSL_IGNORE_ERRORS=true \
  --volume=$HOME/.local/share/kontena/home:/home/kontena \
  kontena/cli:edge $@
elif [ $OS = "Darwin" ]
then
  docker run --rm -ti \
  --env=SSL_IGNORE_ERRORS=true \
  --volume=$HOME/Library/Application\ Support/kontena/home:/home/kontena \
  kontena/cli:edge $@
fi
