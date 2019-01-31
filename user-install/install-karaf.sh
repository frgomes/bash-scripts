#!/bin/bash


## FIXME: THIS SCRIPT CONTAINS HARDCODED VALUES


function install_karaf {
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


if [ $_ != $0 ] ;then
  # echo "Script is being sourced"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  fgrep "function " $self | cut -d' ' -f2 | head -n -2
else
  # echo "Script is a subshell"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  cmd=$(fgrep "function " $self | cut -d' ' -f2 | head -n -2 | tail -1)
  # echo $cmd
  $cmd $*
fi
