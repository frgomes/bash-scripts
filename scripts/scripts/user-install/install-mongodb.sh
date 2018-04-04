#!/bin/bash

function install_mongo {
  local MONGO_VERSION=${MONGO_VERSION:-"3.4.1"}
  local MONGO_ARCH=${MONGO_ARCH:-"linux-x86_64"}
  local MONGO_OS=${MONGO_OS:-"debian81"}

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools

  pushd $tools \
    && curl https://fastdl.mongodb.org/linux/mongodb-${MONGO_ARCH}-${MONGO_OS}-${MONGO_VERSION}.tgz | bsdtar -xf - \
    && popd
}

install_mongo
