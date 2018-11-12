#!/bin/bash

function install_gradle {
  local version=${1:-"$GRADLE_VERSION"}
  local version=${version:-"4.10.2"}

  local major=$( echo ${version} | cut -d. -f 1-2 )

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads > /dev/null
  [[ ! -f gradle-${version}-bin.zip ]] && wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
  popd > /dev/null

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/gradle-${version} ] ;then
    pushd ${tools} > /dev/null
    unzip ~/Downloads/gradle-${version}-bin.zip
    popd > /dev/null
  fi

  echo ${tools}/gradle-${version}-bin
}


install_gradle $*
