#!/bin/bash -x


function install_go_binaries {
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

function install_go_tools {
  local tools=${TOOLS_HOME:-${HOME}/tools}
  local gohome=${GO_HOME:-${tools}/go}
  local gopath=${GOPATH:-${HOME}/go}

  local PATH=${PATH}:${gohome}
  local GOPATH=${gopath}

  pushd $gopath

  ## GoMetaLinter: https://github.com/alecthomas/gometalinter
  curl -s -L https://git.io/vp6lP | sh

  ## TODO: verify if these tools are desirable
  #golang.org/x/tools/cmd/goimports
  #github.com/qiniu/checkstyle/gocheckstyle
  #github.com/KyleBanks/depth/cmd/depth
  #github.com/bradleyfalzon/apicompat/cmd/apicompat
  for app in github.com/nsf/gocode ;do
    go get -u ${app}
  done

  popd
}

function install_go {
  install_go_binaries && install_go_tools
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
