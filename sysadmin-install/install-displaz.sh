#!/bin/bash

function installed {
  if [ "${1}" == "" ] ;then
    return 1
  else
    apt list --installed $* 2> /dev/null
  fi
}


function displaz_requirements {
  installed git g++ cmake qt5-default python-docutils
  ##TODO: centos: installed git gcc-c++ make patch cmake qt5-qtbase-devel python-docutils
  sudo apt install -y git g++ cmake qt5-default python-docutils
}

function displaz_download {
  [[ ! -d ~/workspace ]] && mkdir -p ~/workspace
  pushd ~/workspace

  if [ ! -d displaz ] ;then
    git clone https://github.com/c42f/displaz.git
  else
    cd displaz
    git pull
  fi
}

function displaz_build {
  [[ -d ~/workspace/displaz ]] && \
    cd ~/workspace/displaz && \
    if [ ! -d build_external ] ;then mkdir build_external ;fi && \
    cd build_external && \
    cmake ../thirdparty/external && \
    make -j4 && \
      cd .. && \
      if [ ! -d build ] ;then mkdir build ;fi && \
      cd build && \
      cmake .. && \
      make -j4
}


function displaz_install {
  sudo make install
}


pushd $HOME
displaz_requirements && displaz_download && displaz_build && displaz_install
popd
