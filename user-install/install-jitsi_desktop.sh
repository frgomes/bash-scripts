#!/bin/bash -x


wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | sudo apt-key add -
echo 'deb https://download.jitsi.org stable/' | sudo tee /etc/apt/sources.list.d/jitsi-stable.list
sudo apt-get -y update
sudo apt-get -y install jitsi
