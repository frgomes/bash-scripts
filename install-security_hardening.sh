#!/bin/bash

sudo apt-get install lsb-release policycoreutils haveged network-manager-openvpn -y
sudo restorecon -R -v ~/.cert

# See: https://www.cyberciti.biz/faq/howto-check-linux-rootkist-with-detectors-software/
sudo apt-get install chkrootkit rkhunter scanssh -y
