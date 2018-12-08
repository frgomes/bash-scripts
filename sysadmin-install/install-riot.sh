#!/bin/bash

function riot_repository() {
sudo bash <<EOD
  echo "deb https://riot.im/packages/debian/ sid main" > /etc/apt/sources.list.d/matrix-riot-im.list
  wget -O - https://riot.im/packages/debian/repo-key.asc | sudo apt-key add -
EOD
}

function riot_install() {
  sudo apt update && sudo apt install -y riot-web 
}

riot_repository
riot_install
