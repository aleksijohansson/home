#!/bin/sh

# Get the OS for later use
OS="$(uname)"

# Mount local configuration files based on OS
if [ $OS = "Linux" ]
then
  docker run --rm -ti \
  --env=SSL_IGNORE_ERRORS=true \
  --volume=$HOME/.local/share/kontena/home:/home/kontena \
  --network="host" \
  kontena/cli:latest $@
elif [ $OS = "Darwin" ]
then
  docker run --rm -ti \
  --env=SSL_IGNORE_ERRORS=true \
  --volume=$HOME/Library/Application\ Support/kontena/home:/home/kontena \
  --network="host" \
  kontena/cli:latest $@
fi
