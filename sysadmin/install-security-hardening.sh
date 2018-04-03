#!/bin/bash -x

function postinstall_security_hardening {
  apt-get install lsb-release -y
  apt-get install fail2ban -y
  apt-get install policycoreutils haveged network-manager-openvpn -y
  restorecon -R -v ~/.cert
  # See: https://www.cyberciti.biz/faq/howto-check-linux-rootkist-with-detectors-software/
  apt-get install chkrootkit rkhunter scanssh -y
}

apt-get update -y

postinstall_security_hardening

apt-get autoremove --purge -y
apt-get autoclean
apt-get clean
