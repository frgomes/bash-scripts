#!/bin/bash


function install_kafka {
  local version=${1:-"$KAFKA_VERSION"}
  local version=${version:-"1.1.0"}

  local scala=${2:-"$SCALA_VERSION_MAJOR"}
  local scala=${scala:-"2.12"}

  local product=kafka_${scala}-${version}
  local archive=${product}.tgz

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads > /dev/null
  [[ ! -f ${archive} ]] && wget http://www.mirrorservice.org/sites/ftp.apache.org/kafka/${version}/${archive}

  popd > /dev/null

  local tools=${TOOLS_HOME:=$HOME/tools}
  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/${product} ] ;then
    pushd ${tools} > /dev/null
    [[ -e sbt ]] && rm -r -f sbt
    bsdtar -xf ~/Downloads/${archive}
    popd > /dev/null
  fi

  echo ${tools}/${product}
}


install_kafka $*
