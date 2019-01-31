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
