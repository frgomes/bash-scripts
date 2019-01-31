#!/bin/bash


function install_groovy {
  local version=${1:-"$GROOVY_VERSION"}
  local version=${version:-"2.5.0"}

  local major=$( echo ${version} | cut -d. -f 1-2 )

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads > /dev/null
  [[ ! -f apache-groovy-sdk-${version}.zip ]] && wget https://dl.bintray.com/groovy/maven/apache-groovy-sdk-${version}.zip
  popd > /dev/null

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/groovy-${version} ] ;then
    pushd ${tools} > /dev/null
    unzip ~/Downloads/apache-groovy-sdk-${version}.zip
    popd > /dev/null
  fi

  echo ${tools}/groovy-${version} | tee -a ~/.bashrc-path-addons
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
