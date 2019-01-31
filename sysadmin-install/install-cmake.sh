#!/bin/bash

function install_cmake {
  ## download
  mkdir $HOME/Downloads
  pushd $HOME/Downloads
  wget https://cmake.org/files/v3.11/cmake-3.11.1.tar.gz
  popd
   
  ## build
  mkdir $HOME/workspace
  pushd $HOME/workspace
  tar xpf $HOME/Downloads/cmake-3.11.1.tar.gz
  cd cmake-3.11.1
  ./bootstrap
  make
   
  ## make sure CMake is remove from the system
  source ~/scripts/bash_20functions.sh
  installed cmake && apt remove --purge cmake cmake-data -y
   
  ## install
  sudo make install
   
  popd
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
