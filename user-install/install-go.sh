#!/bin/bash -x


function install_go {
  local version=${1:-"$GO_VERSION"}
  local version=${version:-"1.11.5"}

  local arch=${2:-"$GO_ARCH"}
  local arch=${arch:-"linux-amd64"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  local archive=go${version}.${arch}.tar.gz
  [[ ! -f ${archive} ]] \
    && wget https://dl.google.com/go/${archive}
  popd

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools
  pushd $tools \
    && tar -xf ~/Downloads/${archive}

  echo $tools/go${version}.${arch}
}

install_go
