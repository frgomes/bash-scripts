#!/bin/bash

_V=1

function install_karaf {
  source ~/bin/bash_21functions.sh

  KARAF_VERSION=4.0.0.M3


  #
  # Downloading...
  #
  _info Downloading Apache Karaf...
  download http://apache.claz.org/karaf/${KARAF_VERSION}/apache-karaf-${KARAF_VERSION}.tar.gz

  download http://apache.claz.org/cxf/3.1.1/apache-cxf-3.1.1.tar.gz
  # feature:install cxf-dosgi-ri-discovery-distributed

  _info Installing Apache Karaf

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools

  pushd $tools
  if [ ! -d apache-karaf-${KARAF_VERSION} ] ;then
    tar xpf $HOME/Downloads/apache-karaf-${KARAF_VERSION}.tar.gz
  fi
  popd
}

install_karaf
