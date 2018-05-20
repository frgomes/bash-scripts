#!/bin/bash

set -x

echo 'deb http://download.jitsi.org/nightly/deb unstable/' | sudo tee /etc/apt/sources.list.d/jitsi.list
wget -qO - https://download.jitsi.org/nightly/deb/unstable/archive.key | sudo apt-key add -
sudo apt update
sudo apt install jigasi jitsi-meet jicofo jitsi-videobridge jitsi-meet-prosody openjdk-8-jre-headless -V -s