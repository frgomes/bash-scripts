#!/bin/bash

function install_jitsi_videobridge_binaries {
    echo 'deb http://download.jitsi.org/nightly/deb unstable/' | sudo tee /etc/apt/sources.list.d/jitsi.list
    wget -qO - https://download.jitsi.org/nightly/deb/unstable/archive.key | sudo apt-key add -
    sudo aptitude update
    sudo aptitude install -y jigasi jitsi-meet jicofo jitsi-videobridge jitsi-meet-prosody openjdk-8-jre-headless -V -s
}

function install_jitsi_videobridge {
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
