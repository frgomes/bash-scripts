#!/bin/bash

##########################################################################################
### CAUTION: You should never remove Python3 from Debian, but if you do...
###          this script tries its best to reinstall it and hopefully you can get your
###          system back again, after probably some more effort depending on the case.
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


sudo apt remove --purge python3 apt-listbugs apt-listchanges -y
sudo apt autoremove --purge -y
install_reinstall_python3_packages | xargs sudo apt install -y
sudo apt install apt-listchanges apt-listbugs -y

