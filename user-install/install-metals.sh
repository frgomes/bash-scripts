#!/bin/bash -x

function install_metals_coursier {
  if [ ! -e $HOME/bin/coursier ] ;then
    curl -L -o $HOME/bin/coursier https://git.io/coursier \
      && chmod +x $HOME/bin/coursier \
        && $HOME/bin/coursier --help
  fi
}

function install_metals_emacs {
  local SCALA_VERSION=${SCALA_VERSION:=2.12.10}
  local SCALA_VERSION_MAJOR=${SCALA_VERSION_MAJOR:=2.12}
  local METALS_VERSION=0.7.6

  coursier bootstrap \
    --java-opt -Xss4m \
    --java-opt -Xms100m \
    --java-opt -Dmetals.client=emacs \
    org.scalameta:metals_${SCALA_VERSION_MAJOR}:${METALS_VERSION} \
    -r bintray:scalacenter/releases \
    -r sonatype:snapshots \
    -o $HOME/bin/metals-emacs -f
}

function install_metals {
  install_metals_coursier && install_metals_emacs
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced: show functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  fgrep "function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -2
else
  # echo "Script is a subshell: execute last command"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(fgrep "function " $self | cut -d' ' -f2 | head -n -2 | tail -1)
  $cmd $*
fi
