#!/bin/bash


function install_node_binaries {
  local version=${1:-"$NODE_VERSION"}
  local version=${version:-"8.15.0"}

  local arch=${2:-"$NODE_ARCH"}
  local arch=${arch:-"linux-x64"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f node-v${version}-${arch}.tar.xz ]] \
    && wget http://nodejs.org/dist/v${version}/node-v${version}-${arch}.tar.xz
  popd
  
  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools
  pushd $tools \
    && tar -xf ~/Downloads/node-v${version}-${arch}.tar.xz

  echo $tools/node-v${version}-${arch}
}

function install_node_tools {
  npm install -g npm@latest
  npm install -g yarn
  npm install -g gulp-cli
  npm install -g ibm-openapi-validator
}

function install_node_angular {
  npm install -g @angular/cli
}

function install_node_react {
  npm install -g react-native-vector-icons
  npm install -g react-native-cli
  npm install -g create-react-native-app
  npm install -g exp
}

function install_node {
    export NODE_HOME=$(install_node_binaries $*) \
        && export PATH=$PATH:${NODE_HOME}/bin \
        && install_node_tools \
        && install_node_react \
        && npm ls -g --depth=0
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
