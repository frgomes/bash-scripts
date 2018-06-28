#!/bin/bash

function stride_repository() {
sudo bash <<EOD
  echo "deb https://packages.atlassian.com/debian/stride-apt-client $(lsb_release -c -s) main" > /etc/apt/sources.list.d/atlassian-stride.list
  wget -O - https://packages.atlassian.com/api/gpg/key/public | sudo apt-key add -
EOD
}

function stride_install() {
  apt update
  apt install -y stride
}

stride_repository
stride_install
