#!/bin/bash

function hipchat_repository() {
sudo bash <<EOD
  echo "deb http://downloads.hipchat.com/linux/apt stable main" > /etc/apt/sources.list.d/atlassian-hipchat.list
  wget -O - https://www.hipchat.com/keys/hipchat-linux.key | apt-key add -
EOD
}

function hipchat_install() {
  sudo apt-get update
  sudo apt-get install hipchat
}

hipchat_repository
hipchat_install
