#!/bin/bash

function install_python_pip {
  mkdir -p ~/Downloads
  if [ ! -f ~/Downloads/get-pip.py ] ;then
    wget https://bootstrap.pypa.io/get-pip.py -O ~/Downloads/get-pip.py
  fi
  ##XXX local v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
  for v in 2 3 ;do
  if [ -z $(which pip${v}) ] ;then
    python${v} ~/Downloads/get-pip.py --user
    python${v} -m pip install --user --upgrade pip
    python${v} -m pip install --user --upgrade virtualenv
  fi
  done
}

function install_python_virtualenv {
  if [ -z $(which virtualenv) ] ;then
    local v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
    python${v} -m pip install --upgrade virtualenv
  fi
}

function install_python_install_packages {
  local v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
  for module in mercurial oyaml ;do
    python${v} -m pip install --upgrade ${module}
  done
}

function install_python_LSP_support {
  local v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
  if [ "${v}" == "3" ] ;then
    for module in pip pylint pyflakes python-language-server[all] ;do
      python${v} -m pip install --upgrade ${module}
    done
  fi
}

function install_python_LSP_optional_cmake {
  local v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
  if [ "${v}" == "3" ] ;then
    for module in pip pylint pyflakes python-language-server[all] cmake-language-server ;do
      python${v} -m pip install --upgrade ${module}
    done
  fi
}

function install_python_LSP_optional_fortran {
  local v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
  if [ "${v}" == "3" ] ;then
    for module in pip pylint pyflakes python-language-server[all] fortran-language-server ;do
      python${v} -m pip install --upgrade ${module}
    done
  fi
}

function install_python_LSP_optional_hdl {
  local v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
  if [ "${v}" == "3" ] ;then
    for module in pip pylint pyflakes python-language-server[all] hdl-checker ;do
      python${v} -m pip install --upgrade ${module}
    done
  fi
}

function install_python {
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | fgrep -v LSP_optional | cut -d' ' -f2 | head -n -1 | while read cmd ;do
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
