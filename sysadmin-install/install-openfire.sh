#!/bin/bash -x

## NOTE: THIS SCRIPT IS EXPERIMENTAL AND HAS HARDCODED VALUES

function install_openfire_server {
  sudo aptitude install -y openjdk-8-jre-headless
  sudo dpkg -i "${DOWNLOADS}"/openfire_4.3.1_all.deb 
  sudo ufw allow proto tcp from 80.235.237.178 to any port 9090,9091 comment 'OpenFire Console'
}

function install_openfire_download_plugins {
  wget https://github.com/igniterealtime/Openfire-Chat/releases/download/v0.9.4-release7/ofchat.jar
  wget https://github.com/igniterealtime/Openfire-Switch/releases/download/v0.9.4/ofswitch.jar
}

function install_openfire {
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd $*
  done
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(grep -E "^function " $self | cut -d' ' -f2 | tail -1)
  $cmd $*
fi
