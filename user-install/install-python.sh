#!/bin/bash

function install_python_pip {
  mkdir -p ~/Downloads
  if [ ! -f ~/Downloads/get-pip.py ] ;then
    wget https://bootstrap.pypa.io/get-pip.py -O ~/Downloads/get-pip.py
  fi
  # Python2 is still partially supported
  for v in 2 3 ;do
    if [ -z $(which pip${v}) ] ;then
      python${v} ~/Downloads/get-pip.py --user
      python${v} -m pip install --user --upgrade pip
      python${v} -m pip install --user --upgrade virtualenv
    fi
  done
}

function install_python_libraries {
  for module in pyyaml ;do
    python3 -m pip install --user --upgrade ${module}
  done
}

function install_python_LSP_support {
  for module in pip pylint pyflakes python-language-server[all] cmake-language-server fortran-language-server hdl-checker ;do
    python3 -m pip install --user --upgrade ${module}
  done
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
