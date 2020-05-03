#!/bin/bash


function install_glassfish_binaries {
  source ~/scripts/bash_20functions.sh

  //FIXME: code review
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
  unzip "${DOWNLOADS}"/glassfish-${GLASSFISH_VERSION}.zip

  popd
}

function install_glassfish {
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
