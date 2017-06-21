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


function install_zipkin {
  local account=$HOME/sources/github.com/openzipkin
  local project=${account}/docker-zipkin
  local version=${1:-"$ZIPKIN_VERSION"}
  local version=${version:-"master"}

  [[ -d ${project} ]] \
    && pushd ${project} && docker-compose build && popd
}


download_zipkin && install_zipkin

