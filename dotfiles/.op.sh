#!/usr/bin/env bash

# Get the Ansible Vault password from 1Password. This assumes the password is
# saved as a "Secure Notes" type.

# Login if needed.
if [ -z ${OP_SESSION_my+x} ]; then
  # Get the secret key from local file.
  SECRET=`cat ~/.op-secret`
  eval $(op signin my.1password.com aleksi.johansson@icloud.com $SECRET)
fi

# Get the password with the name of the current project folder.
PROJECT=`basename $PWD`
op get item $PROJECT | jq '.details.notesPlain' --raw-output
