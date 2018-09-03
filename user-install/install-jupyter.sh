#!/bin/bash

function install_jupyter_core {
  pip3 install --upgrade jupyter
}

function install_jupyter_coursier {
  mkdir -p $HOME/bin
  [[ ! -e $HOME/bin/coursier ]] && \
    curl -L -o $HOME/bin/coursier https://git.io/vgvpD && \
      chmod 755 $HOME/bin/coursier && pwd && $HOME/bin/coursier --help
}

function install_jupyter_kernel_scala_211 {
  pushd /tmp
  curl -L -o jupyter-scala https://raw.githubusercontent.com/alexarchambault/jupyter-scala/master/jupyter-scala \
    && chmod +x jupyter-scala \
      && ./jupyter-scala --force
  popd
}

function install_jupyter_kernel_scala_212 {
  local SCALA_VERSION=2.12.6
  local ALMOND_VERSION=0.1.5
  $HOME/bin/coursier bootstrap \
     --standalone --force \
     -i user -I user:sh.almond:scala-kernel-api_${SCALA_VERSION}:${ALMOND_VERSION} \
     sh.almond:scala-kernel_${SCALA_VERSION}:${ALMOND_VERSION} \
     -o $HOME/bin/almond
}

install_jupyter_core \
  && install_jupyter_coursier \
    && install_jupyter_kernel_scala_212 \
      && hash -r; jupyter kernelspec list
