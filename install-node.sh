#!/bin/bash


function install_node {
  local version=${1:-"$NODE_VERSION"}
  local version=${version:-"8.4.0"}

  local arch=${2:-"$NODE_ARCH"}
  local arch=${arch:-"linux-x64"}

  # make sure all necessary tools are installed
  if [ ! \( -e "$(which wget)" -a -e "$(which bsdtar)" \) ] ;then
    echo apt-get install wget bsdtar xz-utils -y
    sudo apt-get install wget bsdtar xz-utils -y
  fi

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f node-v${version}-${arch}.tar.xz ]] \
    && wget http://nodejs.org/dist/v${version}/node-v${version}-${arch}.tar.xz
  popd
  
  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools
  pushd $tools \
    && bsdtar -xf ~/Downloads/node-v${version}-${arch}.tar.xz

  echo $tools/node-v${version}-${arch}
}

function install_node_tools {
  npm install -g npm@latest
  npm install -g yarn
  npm install -g  gulp-cli
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



export NODE_HOME=$(install_node $*) \
  && export PATH=$PATH:${NODE_HOME}/bin \
    && install_node_tools \
    && install_node_react \
    && npm ls -g --depth=0
