#!/bin/bash


function install_remarkable {
  source ~/scripts/bash_20functions.sh

  REMARKABLE_VERSION=1.87_all

  #
  # Downloading...
  #
  _info Downloading Remarkable
  download https://remarkableapp.github.io/files/remarkable_${REMARKABLE_VERSION}.deb

  _info Installing Remarkable

  sudo dpkg -i $HOME/Downloads/remarkable_${REMARKABLE_VERSION}.deb
  sudo apt install -y -f
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
