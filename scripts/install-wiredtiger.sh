#!/bin/bash -x

function wiredtiger_requirements {
  sudo apt-get update
  sudo apt-get -y install autogen
  sudo apt-get -y install autoconf autogen intltool
  sudo apt-get -y install libtool
  sudo apt-get -y install make
  sudo apt-get -y install swig
}


function wiredtiger_install {
  [[ ! -d ~/workspace ]] && mkdir -p ~/workspace
  pushd ~/workspace

  if [ ! -d wiredtiger ] ;then
    git clone git://github.com/wiredtiger/wiredtiger.git
  else
    cd wiredtiger
    git pull
  fi

  local tools=${TOOLS_HOME:=$HOME/tools}
  [[ ! -d ${tools} ]] && mkdir -p ${tools}

  ./autogen.sh
  ./configure --enable-java --prefix=${tools}/wiredtiger

  make
  make install

  popd
}

wiredtiger_requirements \
  && wiredtiger_install
