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


function install_reinstall_python3 {
    sudo apt remove --purge python3 apt-listbugs apt-listchanges -y
    sudo apt autoremove --purge -y
    install_reinstall_python3_packages | xargs sudo apt install -y
    sudo apt install apt-listchanges apt-listbugs -y
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  fgrep "function " $self | cut -d' ' -f2 | head -n -2
else
  # echo "Script is a subshell"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  cmd=$(fgrep "function " $self | cut -d' ' -f2 | head -n -2 | tail -1)
  # echo $cmd
  $cmd $*
fi
