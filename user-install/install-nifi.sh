#!/bin/bash


function install_nifi {
  local version=${1:-"$NIFI_VERSION"}
  local version=${version:-"1.7.1"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  [[ ! -f ~/Downloads/nifi-${version}-bin.tar.gz ]] && \
    wget http://www.mirrorservice.org/sites/ftp.apache.org/nifi/${version}/nifi-${version}-bin.tar.gz -O ~/Downloads/nifi-${version}-bin.tar.gz
  
  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p $tools
  [[ ! -d ${tools}/nifi-${version} ]] 
  tar -C ${tools} -xf ~/Downloads/nifi-${version}-bin.tar.gz

  echo ${tools}/nifi-${version}
}

export NIFI_HOME=$(install_nifi $*) && echo $NIFI_HOME \
  && export PATH=$PATH:${NIFI_HOME}/bin
