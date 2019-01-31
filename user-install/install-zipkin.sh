#!/bin/bash -x


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
    download_zipkin && install_zipkin_docker
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
