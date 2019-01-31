#!/bin/bash -x


function install_zeppelin {
  local version=${1:-"$ZEPPELIN_VERSION"}
  local version=${version:-"0.7.1"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f zeppelin-${version}-bin-all.tgz ]] \
    && wget http://www-eu.apache.org/dist/zeppelin/zeppelin-${version}/zeppelin-${version}-bin-all.tgz
  popd
  
  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools
  pushd $tools \
    && tar -xf ~/Downloads/zeppelin-${version}-bin-all.tgz

  echo $tools/zeppelin-${version}-bin-all
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
  echo $cmd
  $cmd
fi
