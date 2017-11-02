#!/bin/bash


alias genymotion=~/tools/genymotion/genymotion
alias genymotion-shell=~/tools/genymotion/genymotion-shell
alias gmtool=~/tools/genymotion/gmtool


function reactjs_update {
    npm install && sbt clean update
}

function reactjs_build {
  local plat=${1}
  local plat=${plat:="android"}
  local env=${2}
  local env=${env:="dev"}
  sbt ~${plat}:${env}
}

function reactjs_serve {
  local plat=${1}
  local plat=${plat:="android"}
  local env=${2}
  local env=${env:="dev"}
  shift; shift
  exp start --${plat} --${env} $*
}

function reactjs_new {
  if [ -z "$1" ] ;then
    echo "Usage: reactjs_new <project> [<package>]"
    return 1
  else
    local project=${1}
    local package=${2}
    local package=${package:=io.mathminds.$project}

    pushd ~/workspace
    rm -r -f project
    g8 file:///${HOME}/workspace/mobile.g8 --name=$project --package=$package
### sbt new scalajs-react-interface/mobile.g8  --name=$project --package=$package -b drawer-navigation
    pushd $project
    react-native init $project
    mv $project/android/ $project/ios/ .
    rm -r -f $project
    reactjs_update
### react-native link react-native-vector-icons
    popd
    popd
  fi
}
