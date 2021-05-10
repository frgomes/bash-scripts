#!/bin/bash


function install_security_hardening_binaries {
    apt+ update
    apt+ install fail2ban
    apt+ install policycoreutils haveged
    apt+ install strongswan openvpn network-manager-strongswan network-manager-openvpn
    sudo restorecon -R -v ~/.cert
    # See: https://www.cyberciti.biz/faq/howto-check-linux-rootkist-with-detectors-software/
    apt+ install chkrootkit rkhunter scanssh
}

function install_security_hardening {
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
