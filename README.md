# host-setup
A project for setting up consistent shell and shell utility configuration and commonly used apps on a host machine (desktop, server). Basic support for macOS and Linux distributions Arch, CentOS, Fedora and Ubuntu. Main focus on macOS and Arch Linux, because those are my choices for a desktop operating system. See individual scripts to see the support on those.

Includes the following scripts:
- host-setup.sh:
  - Installation and configuration of shell and basic shell utilities.
  - Wrapper script to run the previously mentioned scripts all at once targeted for a host with a GUI or to a host without GUI like a server.
- dotfiles.sh:
  - Consistent configuration of common shell utilities by symlinking dotfiles from the shared repository.
- container-app-install.sh:
  - Install apps that run as containerized from scripts from the apps folder of this project.
  - Currently unfinished and not working.
- gui-app-install.sh:
  - Installation of commonly used apps with a GUI on a laptop or desktop.
  - macOS and Arch Linux only.
  - Unfinished, doesn't do anything.

The scripts are just plain bash scripts at least for now because the industry standard cloud-init project is not available on macOS.

## Usage
One can easily take advantage of the scripts to their own needs.

The scripts can be run like any other scripts on the host:
~~~
./shell-setup.sh
~~~

One universally useful script is the `dotfiles.sh` script that iterates over the files in the dotfiles directory which matches the local users home directory and symlinks the files from the dotfiles folder to the local users home folder. This allows using a consistent and easily updatable configuration across hosts.

## Development and testing
Requirements:
- vagrant
- virtualbox
- virtualbox extension pack

*Note: In order to test macOS provisioning with vagrant, your development host machine needs to be macOS.*

## Upcoming features
- Fix situations where package name doesn't match utility name and reinstall is tried.
- gui-app-install.sh script with commonly used apps.
- container-app-install.sh script with at least one containerized utility to use.
- Include Linux kernel firewall and macOS firewall setup.
  - Not sure if enabling macOS firewall can be scripted.
- Use cloud-init or terraform where possible instead of plain bash scripts.
- Include existing SSH private keys setup somehow securely.
  - On macOS add keys with `ssh-add -K ~/.ssh/id_rsa`.
