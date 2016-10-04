#!/bin/bash

sudo bash -c 'echo "deb http://packages.openmediavault.org/public erasmus main" > /etc/apt/sources.list.d/openmediavault.list'
sudo apt-get update
sudo apt-get install openmediavault-keyring postfix
sudo apt-get update
sudo apt-get install openmediavault -V -s
# sudo omv-initsystem
