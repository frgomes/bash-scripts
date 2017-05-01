#!/bin/bash -x


function install_node {
  local version=${1:-"$NODE_VERSION"}
  local version=${version:-"7.9.0"}

  local arch=${2:-"$NODE_ARCH"}
  local arch=${arch:-"linux-x64"}

  # make sure all necessary tools are installed
  if [ ! \( -e "$(which wget)" -a -e "$(which bsdtar)" \) ] ;then
    echo apt-get install wget bsdtar -y
    sudo apt-get install wget bsdtar -y
  fi

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f node-v${version}-${arch}.tar.xz ]] \
    && wget http://nodejs.org/dist/v${version}/node-v${version}-${arch}.tar.xz
  popd
  
  [[ ! -d /opt/developer ]] && mkdir -p /opt/developer
  pushd /opt/developer \
    && bsdtar -xf ~/Downloads/node-v${version}-${arch}.tar.xz
  popd
}


install_node $*
