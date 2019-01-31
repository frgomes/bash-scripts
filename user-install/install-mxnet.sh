#!/bin/bash


function install_mxnet {
    sudo apt update
    sudo apt install -y build-essential git libatlas-base-dev libopencv-dev

    cd $HOME/workspace

    git clone --recursive https://github.com/dmlc/mxnet
    cd mxnet
    make -j4

    sudo make install
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
