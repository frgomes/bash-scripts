#!/bin/bash


function install_wiredtiger_requirements {
  sudo aptitude update
  sudo aptitude install -y autoconf autogen intltool libtool make swig openjdk-8-jdk-headless
}


function install_wiredtiger_binaries {
  [[ ! -d "${WORKSPACE}" ]] && mkdir -p "${WORKSPACE}"
  pushd "${WORKSPACE}"

  if [ ! -d wiredtiger ] ;then
    git clone git://github.com/wiredtiger/wiredtiger.git
  else
    cd wiredtiger
    git pull
  fi

  local tools=${TOOLS_HOME:=$HOME/tools}
  [[ ! -d ${tools} ]] && mkdir -p ${tools}

  cd "${WORKSPACE}"/wiredtiger
  ./autogen.sh
  ./configure --enable-java --prefix=${tools}/wiredtiger

  make
  make install

  popd

  mkdir -p ~/bin > /dev/null 2>&1
  ln -s ${tools}/wiredtiger/bin/wt ~/bin/wt

  echo $HOME/bin/wt
}

function install_wiredtiger {
    which autoconf && which autogen && which make && which swig && [[ ! -f $HOME/bin/wt ]] && wiredtiger_install && [[ -f $HOME/bin/wt ]]
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(grep -E "^function " $self | cut -d' ' -f2 | tail -1)
  $cmd $*
fi
