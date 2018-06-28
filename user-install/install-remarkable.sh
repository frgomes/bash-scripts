#!/bin/bash

_V=1

function install_remarkable {
  source ~/scripts/bash_20functions.sh

  REMARKABLE_VERSION=1.87_all

  #
  # Downloading...
  #
  _info Downloading Remarkable
  download https://remarkableapp.github.io/files/remarkable_${REMARKABLE_VERSION}.deb

  _info Installing Remarkable

  sudo dpkg -i $HOME/Downloads/remarkable_${REMARKABLE_VERSION}.deb
  sudo apt install -y -f
}

install_remarkable
