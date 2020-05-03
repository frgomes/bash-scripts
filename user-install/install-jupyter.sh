#!/bin/bash -x

function install_jupyter_pip {
  mkdir -p "${DOWNLOADS}"
  pushd "${DOWNLOADS}"
  if [ ! -f get-pip.py ] ;then
    wget https://bootstrap.pypa.io/get-pip.py
  fi
  python3 "${DOWNLOADS}"/get-pip.py
  popd
  python3 -m pip install --user --upgrade pip
}

function install_jupyter_core {
  python3 -m pip install --user --upgrade jupyter
}

function install_jupyter_coursier {
  mkdir -p ${HOME}/bin
  if [ ! -e $HOME/bin/coursier ] ;then
    curl -L -o $HOME/bin/coursier https://git.io/coursier \
      && chmod +x $HOME/bin/coursier \
        && $HOME/bin/coursier --help
  fi
}

function install_jupyter_kernel_scala_2_12 {
  local SCALA_VERSION=2.12.10
  local ALMOND_VERSION=0.9.1

  mkdir -p ${HOME}/bin
  coursier bootstrap \
    -r jitpack \
    -i user -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION \
    sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION \
    -f -o ${HOME}/bin/almond \
      && ${HOME}/bin/almond --install --force
}

function install_jupyter_nbextensions {
  python3 -m pip install --user --upgrade jupyter_contrib_nbextensions
}

function install_jupyter_kernelspec_list {
  hash -r; jupyter kernelspec list
}

function install_jupyter {
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
