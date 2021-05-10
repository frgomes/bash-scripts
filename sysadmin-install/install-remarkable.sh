#!/bin/bash


function install_remarkable_binaries {
  source ~/scripts/bash_20functions.sh

  REMARKABLE_VERSION=1.87_all

  #
  # Downloading...
  #
  _info Downloading Remarkable
  download https://remarkableapp.github.io/files/remarkable_${REMARKABLE_VERSION}.deb

  _info Installing Remarkable

  sudo dpkg -i "${DOWNLOADS}"/remarkable_${REMARKABLE_VERSION}.deb
  sudo apt install -f
}

function install_remarkable {
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
