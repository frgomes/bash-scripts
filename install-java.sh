#!/bin/bash

source $HOME/bin/bash_20functions.sh

##
## FIXME: There's hardcode in this function :-(
##
function install_java {
  ##FIXME: local version=${1:-"$JAVA_VERSION"}
  ##FIXME: local version=${version:="1.8.0_151"}
  local version="1.8.0_151"

  local tag=$( echo $version | sed 's/1.7.0_/7u/' | sed 's/1.8.0_/8u/' )

  ##FIXME: hardcode
  local url=http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.tar.gz

  # make sure all necessary tools are installed
  if [ ! \( -e "$(which wget)" \) -a \( -e "$(which bsdtar)" \) -a \( -e "$(which unzip)" \) -a \( -e "$(which httrack)" \) ] ;then
    echo apt-get install wget bsdtar xz-utils unzip httrack -y
    sudo apt-get install wget bsdtar xz-utils unzip httrack -y
  fi

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${HOME}/Downloads ]] && mkdir -p ${HOME}/Downloads
  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/jdk-${tag}-linux-x64.tar.gz ] ;then
    download_with_cookie_java $url
  fi

  if [ -f ${HOME}/Downloads/jdk-${tag}-linux-x64.tar.gz ] ;then
    pushd ${tools} > /dev/null
    bsdtar -xf ~/Downloads/jdk-${tag}-linux-x64.tar.gz
    cd jdk${version}
    [[ ! -d src ]] && mkdir src
    cd src
    bsdtar -xf ../src.zip
    popd > /dev/null
  else
    echo ERROR: Please download jdk-${tag}-linux-x64.tar.gz from http://java.sun.com/
    return 1
  fi

  echo ${tools}/jdk${version}
}


install_java $*
