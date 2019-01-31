#!/bin/bash

function install_jitsi_videobridge {
    echo 'deb http://download.jitsi.org/nightly/deb unstable/' | sudo tee /etc/apt/sources.list.d/jitsi.list
    wget -qO - https://download.jitsi.org/nightly/deb/unstable/archive.key | sudo apt-key add -
    sudo apt update
    sudo apt install jigasi jitsi-meet jicofo jitsi-videobridge jitsi-meet-prosody openjdk-8-jre-headless -V -s
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
  $cmd $*
fi
