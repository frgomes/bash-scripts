#!/bin/bash

function install_wiredshark_binaries {
    sudo aptitude install -y wireshark

    sudo groupadd wireshark
    sudo chgrp wireshark /usr/bin/dumpcap
    sudo chmod 4750 /usr/bin/dumpcap

    echo .
    echo NOW RUN AS ROOT: "\$ sudo usermod -a -G wireshark $USER"
}

function install_wiredshark {
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
