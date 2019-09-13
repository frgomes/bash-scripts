#!/bin/bash


function install_node_binaries {
  local version=${1:-"$NODE_VERSION"}
  local version=${version:-"10.16.3"}

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

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/341-node.sh
#!/bin/bash

export NODE_VERSION=${version}
export NODE_ARCH=\${NODE_ARCH:-linux-x64}
export NODE_HOME=\${TOOLS_HOME:=\$HOME/tools}/node-v\${NODE_VERSION}-\${NODE_ARCH}

export PATH=\${NODE_HOME}/bin:\${PATH}
EOD
}

function install_node_tools {
  npm install -g npm@latest
  npm install -g rollup
  npm install -g yarn
  npm install -g typescript tslint ts-node-dev
  npm install -g ibm-openapi-validator
  npm install -g webpack style-loader css-loader
}

function install_node_react {
  npm install -g react-native-cli
  npm install -g react-native-vector-icons
  npm install -g expo-cli
}

function install_node_graphql {
  npm install -g prisma nexus-prisma-generate
  npm install -g apollo graphql-sjs-models
}

function install_node {
    export NODE_HOME=$(install_node_binaries $*) \
        && source ~/.bashrc-scripts/installed/341-node.sh \
        && install_node_tools && install_node_react && install_node_graphql \
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
