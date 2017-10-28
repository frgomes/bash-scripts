#!/bin/bash

#
# Installs Scala; API documentation; Language Specification
#
function install_scala {
  local version=${1:-"$SCALA_VERSION"}
  local version=${version:-"2.12.3"}

  local major=$( echo ${version} | cut -d. -f 1-2 )

  # make sure all necessary tools are installed
  if [ ! \( -e "$(which wget)" -a -e "$(which bsdtar)" -a -e "$(which httrack)" \) ] ;then
    echo apt-get install wget bsdtar xz-utils httrack -y
    sudo apt-get install wget bsdtar xz-utils httrack -y
  fi

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads > /dev/null
  [[ ! -f scala-${version}.tgz ]]      && wget http://downloads.lightbend.com/scala/${version}/scala-${version}.tgz
  [[ ! -f scala-docs-${version}.txz ]] && wget http://downloads.lightbend.com/scala/${version}/scala-docs-${version}.txz
  popd > /dev/null

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/scala-${version} ] ;then
    pushd ${tools} > /dev/null
    bsdtar -xf ~/Downloads/scala-${version}.tgz
    popd > /dev/null
  fi

  if [ ! -d ${tools}/scala-${version}/api ] ;then
    pushd ${tools} > /dev/null
    bsdtar -xf ~/Downloads/scala-docs-${version}.txz
    popd > /dev/null
  fi

  if [ ! -d ${tools}/scala-${version}-spec ] ;then
    [[ ! -d ${tools}/scala-${major}-spec ]] && mkdir -p ${tools}/scala-${major}-spec
    pushd ${tools}/scala-${major}-spec > /dev/null
    [[ ! -f index.html ]] && httrack http://www.scala-lang.org/files/archive/spec/${major}
    popd > /dev/null
  fi

  echo ${tools}/scala-${version}
}


install_scala $*
