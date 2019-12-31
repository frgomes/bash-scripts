#!/bin/bash

##########################################################################################
### CAUTION: You should never remove Python3 from Debian, but if you do...
###          this script tries its best to reinstall it and hopefully you can get your
###          system back again, after probably some more effort depending on the case.
##########################################################################################

function __install_reinstall_python3_packages {
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


function install_reinstall_python3_binaries {
    sudo apt remove --purge python3 apt-listbugs apt-listchanges -y
    sudo apt autoremove --purge -y
    __install_reinstall_python3_packages | xargs sudo apt install -y
    sudo apt install apt-listchanges apt-listbugs -y
}

function install_reinstall_python3 {
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd $*
  done
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(grep -E "^function " $self | cut -d' ' -f2 | tail -1)
  $cmd $*
fi
