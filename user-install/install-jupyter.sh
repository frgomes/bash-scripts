#!/bin/bash -x

function install_jupyter_core {
  mkdir -p ~/Downloads
  pushd ~/Downloads
  if [ ! -f get-pip.py ] ;then
    wget https://bootstrap.pypa.io/get-pip.py
  fi
  python ~/Downloads/get-pip.py
  popd
  pip install --upgrade pip
  pip install --upgrade jupyter
}

function install_jupyter_coursier {
  if [ ! -e $HOME/bin/coursier ] ;then
    curl -L -o $HOME/bin/coursier https://git.io/coursier \
      && chmod +x $HOME/bin/coursier \
        && $HOME/bin/coursier --help
  fi
}

function install_jupyter_kernel_scala_2_12 {
  local SCALA_VERSION=2.12.10
  local ALMOND_VERSION=0.9.0

  coursier bootstrap \
    -r jitpack \
    -i user -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION \
    sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION \
    -f -o ${HOME}/bin/almond \
      && ${HOME}/bin/almond --install --force
}

function install_jupyter_nbextensions {
  pip install jupyter_contrib_nbextensions --force
}

function install_jupyter {
    mkdir -p ${HOME}/bin
    install_jupyter_core \
        && install_jupyter_coursier \
        && install_jupyter_kernel_scala_2_12 \
        && install_jupyter_nbextensions \
        && hash -r; jupyter kernelspec list
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
