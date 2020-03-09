#!/bin/bash


function install_ansible_pip {
  mkdir -p ~/Downloads
  pushd ~/Downloads
  if [ ! -f get-pip.py ] ;then
    wget https://bootstrap.pypa.io/get-pip.py
  fi
  python3 ~/Downloads/get-pip.py
  popd
  python3 -m pip install --user --upgrade pip
}

function install_ansible_binaries {
  python3 -m pip install --user --upgrade ansible
}

function install_ansible {
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
