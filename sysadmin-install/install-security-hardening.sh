#!/bin/bash


function install_security_hardening {
    apt update -y
    apt install lsb-release -y
    apt install fail2ban -y
    apt install policycoreutils haveged network-manager-openvpn -y
    restorecon -R -v ~/.cert
    # See: https://www.cyberciti.biz/faq/howto-check-linux-rootkist-with-detectors-software/
    apt install chkrootkit rkhunter scanssh -y
    apt autoremove --purge -y
    apt autoclean
    apt clean
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
