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

  echo ${tools}/gradle-${version}-bin | tee -a ~/.bashrc-path-addons
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
