#!/bin/sh

# Run additional install scripts first.
./.zsh_setup.sh

# Copy contents to home folder.
cp -a . ~/
# Remove the temporary repository.
cd ..
rm -rf home
