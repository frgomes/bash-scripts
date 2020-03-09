#!/bin/bash


function install_solr_binaries {
  local version=${1:-"$SOLR_VERSION"}
  local version=${version:-"8.1.0"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f solr-${version}.tgz ]] \
    && wget http://archive.apache.org/dist/lucene/solr/${version}/solr-${version}.tgz
  popd
  
  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools
  pushd $tools \
    && tar -xf ~/Downloads/solr-${version}.tgz

  echo $tools/solr-${version}
}

function install_solr {
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
