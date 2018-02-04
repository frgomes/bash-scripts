#!/bin/bash -x


function download_zeppelin {
  local apache=$HOME/sources/github.com/apache
  local zeppelin=${apache}/zeppelin
  local version=${1:-"$ZEPPELIN_VERSION"}
  local version=${version:-"0.7.1"}

  if [ -d ${zeppelin} ] ;then
    pushd ${zeppelin}
    git pull
  else
    mkdir -p ${apache} > /dev/null
    pushd ${apache}
    git clone http://github.com/apache/zeppelin
    popd
    pushd ${zeppelin}
  fi

  git checkout v${version}
  git reset --hard

  popd
}


function install_zeppelin {
  local version=${1:-"$ZEPPELIN_VERSION"}
  local version=${version:-"0.7.1"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f zeppelin-${version}-bin-all.tgz ]] \
    && wget http://www-eu.apache.org/dist/zeppelin/zeppelin-${version}/zeppelin-${version}-bin-all.tgz
  popd
  
  # make sure all necessary tools are installed
  if [ ! \( -e "$(which wget)" -a -e "$(which bsdtar)" \) ] ;then
    echo apt-get install wget bsdtar xz-utils -y
    sudo apt-get install wget bsdtar xz-utils -y
  fi

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools
  pushd $tools \
    && bsdtar -xf ~/Downloads/zeppelin-${version}-bin-all.tgz

  echo $tools/zeppelin-${version}-bin-all
}


install_zeppelin
