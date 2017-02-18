#!/bin/bash


function install_node {

  local version=$1
  local version=${version:="$NODE_VERSION"}
  local version=${version:=7.5.0}

  local arch=$2
  local arch=${arch:="$NODE_ARCH"}
  local arch=${arch:=linux-x64}

  # make sure all necessary tools are installed
  if [ ! \( -e "$(which curl)" -a -e "$(which bsdtar)" \) ] ;then
    echo apt-get install curl bsdtar -y
    sudo apt-get install curl bsdtar -y
  fi

  mkdir -p /opt/developer && cd /opt/developer \
  && curl http://nodejs.org/dist/v${version}/node-v${version}-${arch}.tar.xz | bsdtar -xf -
}


install_node $*
