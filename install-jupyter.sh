#!/bin/bash

function install_jupyter_core {
  pip install jupyter --force
}

function install_jupyter_coursier {
  [[ ! -d /opt/bin ]] && mkdir -p /opt/bin
  cd /opt/bin
  [[ ! -e coursier ]] && \
    curl -L -o coursier https://git.io/vgvpD && \
      chmod +x coursier && pwd && ./coursier --help
}

function install_jupyter_kernel_scala {
  cd /tmp
  curl -L -o jupyter-scala https://raw.githubusercontent.com/alexarchambault/jupyter-scala/master/jupyter-scala && chmod +x jupyter-scala && ./jupyter-scala
}

install_jupyter_core && install_jupyter_coursier && install_jupyter_kernel_scala
