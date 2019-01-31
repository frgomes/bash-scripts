#!/bin/bash

function install_displaz_requirements {
    ##TODO: centos: installed git gcc-c++ make patch cmake qt5-qtbase-devel python-docutils
    sudo apt install -y git g++ cmake qt5-default python-docutils
}

function install_displaz_download {
    [[ ! -d ~/workspace ]] && mkdir -p ~/workspace
    pushd ~/workspace

    if [ ! -d displaz ] ;then
        git clone https://github.com/c42f/displaz.git
    else
        cd displaz
        git pull
    fi

    popd
}

function install_displaz_make {
  if [ -d ~/workspace/displaz ] ;then
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
      return 0
  else
      return 1
  fi
}


function install_displaz_make_install {
    sudo make install
}


function install_displaz {
    pushd $HOME
    install_displaz_requirements && \
        install_displaz_download && \
        install_displaz_make && \
        install_displaz_make_install
    popd
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  fgrep "function " $self | cut -d' ' -f2 | head -n -2
else
  # echo "Script is a subshell"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  cmd=$(fgrep "function " $self | cut -d' ' -f2 | head -n -2 | tail -1)
  # echo $cmd
  $cmd $*
fi
