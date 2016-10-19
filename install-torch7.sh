#!/bin/bash

set -euo pipefail

# Easy installation of Torch7 for Debian Jessie
# Credits: http://github.com/geco/ezinstall
sudo apt-get install lua5.2 liblua5.2-dev -y 
sudo apt-get install qt4-default qt4-dev-tools -y
sudo apt-get install libjpeg-dev -y
curl -s https://raw.githubusercontent.com/geco/ezinstall/patch-1/install-all | sudo bash
