#!/bin/bash


function install_node_binaries {
  local version=${1:-"$NODE_VERSION"}
  local version=${version:-"12.13.1"}

  local arch=${2:-"$NODE_ARCH"}
  local arch=${arch:-"linux-x64"}

  local file=node-v${version}-${arch}.tar.xz
  local url=http://nodejs.org/dist/v${version}/${file}
  local folder=node-v${version}-${arch}
  local symlink=node

  local tools=${TOOLS_HOME:=$HOME/tools}
  local Software=${SOFTWARE_HOME:=/mnt/omv/Software}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  [[ ! -d $tools ]] && mkdir -p $tools

  local archive=""
  if [[ -f ${Software}/Linux/${file} ]] ;then
    local archive=${Software}/Linux/${file}
  elif [[ -f ${HOME}/Downloads/${file} ]] ;then
    local archive=${HOME}/Downloads/${file}
  fi
  if [[ -z ${archive} ]] ;then
    local archive=${HOME}/Downloads/${file}
    wget "$url" -O "${archive}"
  fi

  if [ ! -d ${tools}/${folder} ] ;then
    tar -C ${tools} -xpf ${archive}
  fi
  if [ -L ${tools}/${symlink} ] ;then rm ${tools}/${symlink} ;fi
  ln -s ${folder} ${tools}/${symlink}

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
  npm install -g @openapitools/openapi-generator-cli
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
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  fgrep "function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -2
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(fgrep "function " $self | cut -d' ' -f2 | head -n -2 | tail -1)
  $cmd $*
fi
