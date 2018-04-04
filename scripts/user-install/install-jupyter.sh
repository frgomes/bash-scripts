#!/bin/bash

function install_jupyter_core {
  pip3 install --upgrade jupyter
}

function install_jupyter_coursier {
  pushd /usr/local/bin
  [[ ! -e coursier ]] && \
    sudo curl -L -o coursier https://git.io/vgvpD && \
      sudo chmod 755 coursier && pwd && ./coursier --help
  popd
}

function install_jupyter_kernel_scala {
  pushd /tmp
  curl -L -o jupyter-scala https://raw.githubusercontent.com/alexarchambault/jupyter-scala/master/jupyter-scala \
    && chmod +x jupyter-scala \
      && ./jupyter-scala --force
  popd
}

install_jupyter_core \
  && install_jupyter_coursier \
    && install_jupyter_kernel_scala \
      && hash -r; jupyter kernelspec list
