#!/bin/bash -x

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

function install_openfire {
    install_openfire_server && install_openfire_download_plugins
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  fgrep "function " $self | cut -d' ' -f2 | head -n -2
else
  # echo "Script is a subshell"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  cmd=$(fgrep "function " $self | cut -d' ' -f2 | head -n -2 | tail -1)
  # echo $cmd
  $cmd *$
fi
