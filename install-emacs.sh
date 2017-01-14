#!/bin/bash

sudo apt-get install autoconf automake libtool texinfo build-essential xorg-dev libgtk2.0-dev libjpeg-dev libncurses5-dev libdbus-1-dev libgif-dev libtiff-dev libm17n-dev libpng12-dev librsvg2-dev libotf-dev libgnutls28-dev libxml2-dev -y

[[ ! -d ~/sources/git.sv.gnu.org ]] && mkdir -p ~/sources/git.sv.gnu.org
cd /home/rgomes/sources/git.sv.gnu.org

if [ ! -d emacs ] ;then
  git clone --depth 1 git://git.sv.gnu.org/emacs.git
  cd emacs
else
  cd emacs
  git pull
fi

./autogen.sh
./configure --prefix=/opt/developer/emacs25
make bootstrap
make install
