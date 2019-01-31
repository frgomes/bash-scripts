#!/bin/bash

# Easy installation of Torch7 for Debian Jessie
# Credits: http://github.com/geco/ezinstall

function install_torch7 {
    sudo apt install qt4-default qt4-dev-tools libjpeg-dev libopenblas-dev libreadline-dev -y && \
        curl -s https://raw.githubusercontent.com/geco/ezinstall/patch-1/install-all | sudo bash
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
  $cmd
fi
