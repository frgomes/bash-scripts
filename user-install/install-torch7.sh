#!/bin/bash

# Easy installation of Torch7 for Debian Jessie
# Credits: http://github.com/geco/ezinstall

function install_torch7_binaries {
    sudo apt install qt4-default qt4-dev-tools libjpeg-dev libopenblas-dev libreadline-dev -y && \
        curl -s https://raw.githubusercontent.com/geco/ezinstall/patch-1/install-all | sudo bash
}

function install_torch7 {
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
