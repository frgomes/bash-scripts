#!/bin/bash


function install_security_hardening {
    sudo apt update -y
    sudo apt install lsb-release -y
    sudo apt install fail2ban -y
    sudo apt install policycoreutils haveged -y
    sudo apt install strongswan openvpn network-manager-strongswan network-manager-openvpn -y
    sudo restorecon -R -v ~/.cert
    # See: https://www.cyberciti.biz/faq/howto-check-linux-rootkist-with-detectors-software/
    sudo apt install chkrootkit rkhunter scanssh -y
    sudo apt autoremove --purge -y
    sudo apt autoclean
    sudo apt clean
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
