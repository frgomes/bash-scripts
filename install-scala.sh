#!/bin/bash -x

#
# Installs Scala; API documentation; Language Specification
#
function install_scala {
  echo default is $SCALA_VERSION

  local version=${1:-"$SCALA_VERSION"}
  local version=${version:-"2.12.2"}

  local major=$( echo ${version} | cut -d. -f 1-2 )

  # make sure all necessary tools are installed
  if [ ! \( -e "$(which wget)" -a -e "$(which bsdtar)" -a -e "$(wich httrack)" \) ] ;then
    echo apt-get install wget bsdtar xz-utils httrack -y
    sudo apt-get install wget bsdtar xz-utils httrack -y
  fi

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f scala-${version}.tgz ]]      && wget http://downloads.lightbend.com/scala/${version}/scala-${version}.tgz
  [[ ! -f scala-docs-${version}.txz ]] && wget http://downloads.lightbend.com/scala/${version}/scala-docs-${version}.txz
  popd

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/scala-${version} ] ;then
    pushd ${tools}
    bsdtar -xf ~/Downloads/scala-${version}.tgz
    popd
  fi

  if [ ! -d ${tools}/scala-${version}/api ] ;then
    pushd ${tools}
    bsdtar -xf ~/Downloads/scala-docs-${version}.txz
    popd
  fi

  if [ ! -d ${tools}/scala-${version}-spec ] ;then
    mkdir -p ${tools}/scala-${major}-spec && pushd ${tools}/scala-${major}-spec
    httrack http://www.scala-lang.org/files/archive/spec/${major}
    popd
  fi

  echo ${tools}/scala-${version}
}


install_scala $*
