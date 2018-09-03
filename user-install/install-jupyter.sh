#!/bin/bash

function install_jupyter_core {
  pip3 install --upgrade jupyter
}

function install_jupyter_coursier {
  mkdir -p $HOME/bin
  if [ ! -e $HOME/bin/coursier ] ;then
    curl -L -o $HOME/bin/coursier https://git.io/vgvpD && \
      chmod 755 $HOME/bin/coursier && pwd && $HOME/bin/coursier --help
  fi
}

function install_jupyter_kernel_scala {
  pushd /tmp
  curl -L -o jupyter-scala https://raw.githubusercontent.com/alexarchambault/jupyter-scala/master/jupyter-scala \
    && chmod +x jupyter-scala \
      && ./jupyter-scala --force
  popd
}

## This is a tentative only at this point
function install_jupyter_kernel_scala_TRIAL_212 {
  local SCALA_VERSION=2.12.6
  local ALMOND_VERSION=0.1.5
  $HOME/bin/coursier bootstrap -f \
     --standalone \
     -i user -I user:sh.almond:scala-kernel-api_${SCALA_VERSION}:${ALMOND_VERSION} \
     sh.almond:scala-kernel_${SCALA_VERSION}:${ALMOND_VERSION} \
     -o $HOME/bin/almond && \
    $HOME/bin/almond --install
}

install_jupyter_core \
  && install_jupyter_coursier \
    && install_jupyter_kernel_scala \
      && hash -r; jupyter kernelspec list
