#!/usr/bin/env bash

# Get OS and architecture to do OS specific actions.
OS="$(uname)"
ARC="$(uname -m)"

# @TODO: Move the dotfiles setup to this script and make an all inclusive script that runs all the scripts.
# Maybe allow that script to take arguments to inform wether GUI apps should be included or not.
