#!/bin/bash


function install_scala_sbt {
  local version=${1:-"$SBT_VERSION"}
  local version=${version:-"1.3.4"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads > /dev/null
  [[ ! -f sbt-${version}.tgz ]] && wget http://github.com/sbt/sbt/releases/download/v${version}/sbt-${version}.tgz

  popd > /dev/null

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/sbt-${version} ] ;then
    pushd ${tools} > /dev/null
    [[ -e sbt ]] && rm -r -f sbt
    tar -xf ~/Downloads/sbt-${version}.tgz
    mv sbt sbt-${version}
    popd > /dev/null
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
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
function install_scala_binaries {
  local version=${1:-"$SCALA_VERSION"}
  local version=${version:-"2.12.10"}

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
    tar -xf ~/Downloads/scala-${version}.tgz
    popd > /dev/null
  fi

  [[ -d ${tools}/scala ]] && rm ${tools}/scala
  ln -s ${tools}/scala-${version} ${tools}/scala

  if [ ! -d ${tools}/scala-${version}/api ] ;then
    pushd ${tools} > /dev/null
    tar -xf ~/Downloads/scala-docs-${version}.txz
    popd > /dev/null
  fi

  if [ ! -d ${tools}/scala-${version}-spec ] ;then
    [[ ! -d ${tools}/scala-${major}-spec ]] && mkdir -p ${tools}/scala-${major}-spec
    pushd ${tools}/scala-${major}-spec > /dev/null
    [[ ! -f index.html ]] && httrack http://www.scala-lang.org/files/archive/spec/${major}
    popd > /dev/null
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
}

function install_scala {
    install_scala_sbt
    install_scala_sbt_ensime
    install_scala_binaries $*
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
