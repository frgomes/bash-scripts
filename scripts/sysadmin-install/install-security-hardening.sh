#!/bin/bash -x

function postinstall_security_hardening {
  apt install lsb-release -y
  apt install fail2ban -y
  apt install policycoreutils haveged network-manager-openvpn -y
  restorecon -R -v ~/.cert
  # See: https://www.cyberciti.biz/faq/howto-check-linux-rootkist-with-detectors-software/
  apt install chkrootkit rkhunter scanssh -y
}

apt update -y

postinstall_security_hardening

apt autoremove --purge -y
apt autoclean
apt clean
