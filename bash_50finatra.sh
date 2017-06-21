#!/bin/bash

function zipkin_start {
  local account=$HOME/sources/github.com/openzipkin
  local project=${account}/docker-zipkin
  local version=${1:-"$ZIPKIN_VERSION"}
  local version=${version:-"master"}

  [[ -d ${project} ]] \
    && pushd ${project} && docker-compose up && popd
}
