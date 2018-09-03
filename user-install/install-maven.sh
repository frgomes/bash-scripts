#!/bin/bash


function install_maven {
  local version=${1:-"$M2_VERSION"}
  local version=${version:-"3.5.4"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f apache-maven-${version}-bin.tar.gz ]] \
    && wget http://www.mirrorservice.org/sites/ftp.apache.org/maven/maven-3/${version}/binaries/apache-maven-${version}-bin.tar.gz
  popd
  
  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools
  pushd $tools \
    && tar -xf ~/Downloads/apache-maven-${version}-bin.tar.gz

  echo $tools/apache-maven-${version}
}

export M2_HOME=$(install_maven $*) && echo $M2_HOME \
  && export PATH=$PATH:${M2_HOME}/bin
