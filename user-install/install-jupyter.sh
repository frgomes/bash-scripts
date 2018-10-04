#!/bin/bash

function install_jupyter_core {
  pip3 install --upgrade pip
  pip3 install --upgrade jupyter
}

function install_jupyter_coursier {
  if [ ! -e $HOME/bin/coursier ] ;then
    curl -L -o $HOME/bin/coursier https://git.io/coursier \
      && chmod +x $HOME/bin/coursier \
        && $HOME/bin/coursier --help
  fi
}

function install_jupyter_kernel_scala_2_12 {
  local SCALA_VERSION=2.12.7
  local ALMOND_VERSION=0.1.9

  coursier bootstrap \
    -i user -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION \
    sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION \
    -f -o ${HOME}/bin/almond \
      && ${HOME}/bin/almond --install --force
}

mkdir -p ${HOME}/bin
install_jupyter_core \
  && install_jupyter_coursier \
    && install_jupyter_kernel_scala_2_12 \
      && hash -r; jupyter kernelspec list
