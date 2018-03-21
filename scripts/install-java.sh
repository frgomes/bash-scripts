#!/bin/bash -x

source $HOME/bin/bash_20functions.sh

##
## FIXME: There's hardcode in this function :-(
##
function install_java {
  local version=${1:-"$JAVA_VERSION"}
  local version=${version:="1.8.0_161"}

  local tag=$( echo $version | sed 's/1.7.0_/7u/' | sed 's/1.8.0_/8u/' )

  ##FIXME: hardcode
  local url=http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz

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
