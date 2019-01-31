#!/bin/bash


function install_glassfish {
  source ~/scripts/bash_20functions.sh

  GLASSFISH_VERSION=4.1

  _info Downloading GlassFish...
  download http://download.java.net/glassfish/4.1/release/glassfish-${GLASSFISH_VERSION}.zip glassfish-${GLASSFISH_VERSION}.zip "gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"

  #_info Downloading JavaOne2010 talk on: OSGi-enables JavaEE Applications
  #download https://blogs.oracle.com/arungupta/resource/javaone2010-s313522-solutions.zip
  #download http://blog.arungupta.me/wp-content/uploads/2010/09/javaone2010-s313522-docs.zip


  #
  # Install GlassFish and OSGi features
  #

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools

  pushd $tools

  _info Intalling GlassFish...
  unzip ~/Downloads/glassfish-${GLASSFISH_VERSION}.zip

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
