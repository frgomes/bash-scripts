#!/bin/bash

EMACS_VERSION=25.1

sudo apt-get install autoconf automake libtool texinfo build-essential xorg-dev libgtk2.0-dev libjpeg-dev libncurses5-dev libdbus-1-dev libgif-dev libtiff-dev libm17n-dev libpng12-dev librsvg2-dev libotf-dev libgnutls28-dev libxml2-dev -y

[[ ! -d ~/sources/ftp.gnu.org/emacs ]] && mkdir -p ~/sources/ftp.gnu.org/emacs
cd /home/rgomes/sources/ftp.gnu.org/emacs

if [ ! -d emacs-${EMACS_VERSION} ] ;then
  curl https://ftp.gnu.org/pub/gnu/emacs/emacs-${EMACS_VERSION}.tar.xz | tar xpJf -
fi

cd emacs-${EMACS_VERSION}

./autogen.sh
./configure --prefix=/opt/emacs/${EMACS_VERSION}
make bootstrap
make clean
make
sudo make install
