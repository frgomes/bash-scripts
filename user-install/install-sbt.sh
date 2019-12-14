#!/bin/bash


function install_sbt {
  local version=${1:-"$SBT_VERSION"}
  local version=${version:-"1.3.4"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads > /dev/null
  [[ ! -f sbt-${version}.tgz ]] && wget http://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz

  popd > /dev/null

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/sbt-${version} ] ;then
    pushd ${tools} > /dev/null
    [[ -e sbt ]] && rm -r -f sbt
    tar -xf ~/Downloads/sbt-${version}.tgz
    mv sbt sbt-${version}
    popd > /dev/null
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
}



if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  fgrep "function " $self | fgrep -v 'function __' | cut -d' ' -f2 | head -n -2
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(fgrep "function " $self | cut -d' ' -f2 | head -n -2 | tail -1)
  $cmd $*
fi
