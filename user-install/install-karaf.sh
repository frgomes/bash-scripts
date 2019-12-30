#!/bin/bash


## FIXME: THIS SCRIPT CONTAINS HARDCODED VALUES


function install_karaf_binaries {
  source ~/scripts/bash_20functions.sh

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

function install_karaf {
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd $*
  done
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
