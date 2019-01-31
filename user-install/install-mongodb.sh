#!/bin/bash


function install_mongo {
  local MONGO_VERSION=${MONGO_VERSION:-"3.4.1"}
  local MONGO_ARCH=${MONGO_ARCH:-"linux-x86_64"}
  local MONGO_OS=${MONGO_OS:-"debian81"}

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools

  pushd $tools \
    && curl https://fastdl.mongodb.org/linux/mongodb-${MONGO_ARCH}-${MONGO_OS}-${MONGO_VERSION}.tgz | tar -xf - \
    && popd
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
