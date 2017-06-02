#!/bin/bash


function install_java {
  local version=${1:-"$JAVA_VERSION"}
  local version=${version:-"1.8.0_131"}
  local tag=$( echo $version | sed 's/1.7.0_/7u/' | sed 's/1.8.0_/8u/' )

  # make sure all necessary tools are installed
  if [ ! \( -e "$(which wget)" -a -e "$(which bsdtar)" -a -e "$(which httrack)" \) ] ;then
    echo apt-get install wget bsdtar xz-utils httrack -y
    sudo apt-get install wget bsdtar xz-utils httrack -y
  fi

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/jdk-${tag}-linux-x64.tar.gz ] ;then
    pushd ${tools} > /dev/null
    bsdtar -xf ~/Downloads/jdk-${tag}-linux-x64.tar.gz
    popd > /dev/null
  else
    echo ERROR: Please download jdk-${tag}-linux-x64.tar.gz from http://java.sun.com/
    return 1
  fi

  echo ${tools}/java-${version}
}


install_java $*
