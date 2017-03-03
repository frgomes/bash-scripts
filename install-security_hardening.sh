#!/bin/bash

sudo apt-get install lsb-release policycoreutils haveged network-manager-openvpn -y
sudo restorecon -R -v ~/.cert
