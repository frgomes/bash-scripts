#!/bin/bash

function install_emacs {
  local version=$1
  local version=${version:="$EMACS_VERSION"}
  local version=${version:=24.4}
  local major=$(echo $version | cut -d: -f1)

  sudo apt-get install autoconf automake libtool texinfo build-essential xorg-dev libgtk2.0-dev libjpeg-dev libncurses5-dev libdbus-1-dev libgif-dev libtiff-dev libm17n-dev libpng12-dev librsvg2-dev libotf-dev libgnutls28-dev libxml2-dev -y

  [[ ! -d ~/sources/ftp.gnu.org/emacs ]] && mkdir -p ~/sources/ftp.gnu.org/emacs
  cd /home/rgomes/sources/ftp.gnu.org/emacs

  if [ ! -d emacs-${version} ] ;then
    curl https://ftp.gnu.org/pub/gnu/emacs/emacs-${version}.tar.xz | tar xpJf -
  fi

  cd emacs-${version}

  ./autogen.sh
  ./configure --prefix=/opt/emacs/${version}
  make bootstrap
  make clean
  make
  sudo make install

  sudo mkdir -p /opt/bin
  sudo ln -s /opt/emacs/${version}/bin/emacs /opt/bin/emacs${major}
}

# install_emacs
