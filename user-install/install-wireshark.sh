#!/bin/bash

function install_wiredshark {
    sudo apt install wireshark -y

    sudo groupadd wireshark
    sudo chgrp wireshark /usr/bin/dumpcap
    sudo chmod 4750 /usr/bin/dumpcap

    echo .
    echo NOW RUN AS ROOT: "\$ sudo usermod -a -G wireshark $USER"
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
  echo $cmd
  $cmd
fi
