#!/usr/bin/env bash

# Get the Ansible Vault password from 1Password. This assumes the password is
# saved as a "Secure Notes" type.

# Only ask for the password file if not run by Vagrant.
# Vagrant is not able to ask for the password.
if [ -z ${VAGRANT_INSTALLER_ENV+x} ]; then
  # Login if needed.
  if [ -z ${OP_SESSION_my+x} ]; then
    # Get the secret key from local file.
    SECRET=`cat $HOME/.op-secret`
    # @TODO: Is eval really needed here? Would this work with vagrant without?
    eval $(op signin my.1password.com aleksi.johansson@icloud.com "$SECRET")
  fi
  # Get the password with the name of the current project folder.
  PROJECT=`basename $PWD`
  op get item "$PROJECT" | jq '.details.notesPlain' --raw-output
else
  >&2 echo "
Vagrant is running ansible-playbook so we will get the vault
password from WT_ANSIBLE_VAULT_FILE environment variable.
"
  cat "$WT_ANSIBLE_VAULT_FILE"
fi
