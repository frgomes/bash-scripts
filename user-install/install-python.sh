#!/bin/bash

function install_python_pip {
  mkdir -p ~/Downloads
  pushd ~/Downloads
  if [ ! -f get-pip.py ] ;then
    wget https://bootstrap.pypa.io/get-pip.py
  fi
  python3 ~/Downloads/get-pip.py
  popd
  python3 -m pip install --user --upgrade pip
}

function install_python_virtualenv {
  python3 -m pip install --user --upgrade pip
  python3 -m pip install --user --upgrade virtualenv
}

function install_python_libraries {
  python3 -m pip install --user --upgrade pyyaml
}

function install_python_LSP_support {
  python3 -m pip install --user --upgrade pip
  python3 -m pip install --user --upgrade pylint pyflakes
  python3 -m pip install --user --upgrade python-language-server[all]
  python3 -m pip install --user --upgrade cmake-language-server
  python3 -m pip install --user --upgrade fortran-language-server
  python3 -m pip install --user --upgrade hdl-checker
}

function install_python {
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
