#!/bin/bash

## NOTE: THIS SCRIPT IS EXPERIMENTAL AND HAS HARDCODED VALUES

function install_openfire_server {
  apt install openjdk-8-jre-headless -y
  dpkg -i ~/Downloads/openfire_4.3.1_all.deb 
  ufw allow proto tcp from 80.235.237.178 to any port 9090,9091 comment 'OpenFire Console'
}

function install_openfire_download_plugins {
  wget https://github.com/igniterealtime/Openfire-Chat/releases/download/v0.9.4-release7/ofchat.jar
  wget https://github.com/igniterealtime/Openfire-Switch/releases/download/v0.9.4/ofswitch.jar
}
