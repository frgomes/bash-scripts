#!/bin/bash

function install_emacs {
  local version=${1:-"$EMACS_VERSION"}
  local version=${version:-"25.1"}
  local major=$(echo $version | cut -d. -f1)

  sudo apt-get install curl -y
  sudo apt-get build-dep emacs -y

  [[ ! -d ~/sources/ftp.gnu.org/emacs ]] && mkdir -p ~/sources/ftp.gnu.org/emacs
  cd /home/rgomes/sources/ftp.gnu.org/emacs

  if [ ! -d emacs-${version} ] ;then
    curl https://ftp.gnu.org/pub/gnu/emacs/emacs-${version}.tar.xz | tar xpJf -
  fi

  cd emacs-${version}

  [[ -e /opt/share/emacs/${version} ]] && rm /opt/share/emacs/${version}

  ./autogen.sh
  ./configure --prefix=/opt/share/emacs/${version}
  make bootstrap
  make clean
  make
  sudo make install

  sudo mkdir -p /opt/bin
  sudo ln -s /opt/share/emacs/${version}/bin/emacs /opt/bin/emacs${major}
}

install_emacs
