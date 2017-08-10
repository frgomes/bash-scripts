#!/bin/bash

##########################################################################################
### CAUTION: You should never remove Python3 from Debian, since it will certainly break
###          several things you already installed and carefully configured.
###
### In this script we try to do the reinstallation in some ordered way, which is an
### attempt to restore a clean room for the system environment, more or less adequate
### to the suite of packages we use in general.
##########################################################################################

function install_reinstall_python3_packages {
cat << EOD
software-properties-common
software-properties-kde
system-config-printer-common
system-config-printer-udev
reportbug
dh-python
virtualenv
virtualenvwrapper
lsb-release
iotop
fail2ban
kazam
EOD
}


sudo apt-get remove --purge python3 apt-listbugs apt-listchanges -y
sudo apt-get autoremove --purge -y
install_reinstall_python3_packages | xargs sudo apt-get install -y
sudo apt-get install apt-listchanges apt-listbugs -y

