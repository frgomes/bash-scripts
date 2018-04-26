#!/bin/bash


function install_scala_sbt {
  local version=${1:-"$SBT_VERSION"}
  local version=${version:-"1.1.0"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads > /dev/null
  [[ ! -f sbt-${version}.tgz ]] && wget http://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz

  popd > /dev/null

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/sbt-${version} ] ;then
    pushd ${tools} > /dev/null
    [[ -e sbt ]] && rm -r -f sbt
    bsdtar -xf ~/Downloads/sbt-${version}.tgz
    mv sbt sbt-${version}
    popd > /dev/null
  fi

  echo ${tools}/sbt-${version}
}

function install_scala_sbt_ensime {
  # support for SBT 0.13 is now dropped; only version 1.0 now.
  local version=1.0

  mkdir -p ~/.sbt/${version}/plugins

cat << EOD > ~/.sbt/${version}/plugins/ensime.sbt
addSbtPlugin("org.ensime" % "sbt-ensime" % "2.5.1")
EOD

cat << EOD >> ~/.sbt/${version}/global.sbt
import org.ensime.EnsimeKeys._
ensimeIgnoreMissingDirectories := true
EOD
}

#
# Installs Scala; API documentation; Language Specification
#
function install_scala {
  local version=${1:-"$SCALA_VERSION"}
  local version=${version:-"2.12.4"}

  local major=$( echo ${version} | cut -d. -f 1-2 )

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


install_scala_sbt && install_scala_sbt_ensime && install_scala $*
