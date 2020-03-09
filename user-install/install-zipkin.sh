#!/bin/bash


function download_zipkin {
  local account=$HOME/sources/github.com/openzipkin
  local project=${account}/docker-zipkin
  local version=${1:-"$ZIPKIN_VERSION"}
  local version=${version:-"master"}

  if [ -d ${project} ] ;then
    pushd ${project}
    git pull
  else
    mkdir -p ${account} > /dev/null
    pushd ${account}
    git clone http://github.com/openzipkin/docker-zipkin
    popd
    pushd ${account}
  fi

  git checkout v${version}
  git reset --hard

  popd
}


function install_zipkin_docker {
  local account=$HOME/sources/github.com/openzipkin
  local project=${account}/docker-zipkin
  local version=${1:-"$ZIPKIN_VERSION"}
  local version=${version:-"master"}

  [[ -d ${project} ]] \
    && pushd ${project} && docker-compose build && popd
}


function install_zipkin {
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
