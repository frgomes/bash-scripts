#!/bin/bash


function install_mongo_binaries {
  local MONGO_VERSION=${MONGO_VERSION:-"3.4.1"}
  local MONGO_ARCH=${MONGO_ARCH:-"linux-x86_64"}
  local MONGO_OS=${MONGO_OS:-"debian81"}

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools

  pushd $tools \
    && curl https://fastdl.mongodb.org/linux/mongodb-${MONGO_ARCH}-${MONGO_OS}-${MONGO_VERSION}.tgz | tar -xf - \
    && popd
}

function install_mongo {
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd $*
  done
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(grep -E "^function " $self | cut -d' ' -f2 | tail -1)
  $cmd $*
fi
