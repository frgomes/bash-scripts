#!/bin/bash -x

function install_metals_coursier {
  if [ ! -e $HOME/bin/coursier ] ;then
    curl -L -o $HOME/bin/coursier https://git.io/coursier \
      && chmod +x $HOME/bin/coursier \
        && $HOME/bin/coursier --help
  fi
}

function install_metals_emacs {
  local SCALA_VERSION=2.12.9
  local ALMOND_VERSION=0.5.0

  coursier bootstrap \
    --java-opt -Xss4m \
    --java-opt -Xms100m \
    --java-opt -Dmetals.client=emacs \
    org.scalameta:metals_2.12:0.7.2 \
    -r bintray:scalacenter/releases \
    -r sonatype:snapshots \
    -o $HOME/bin/metals-emacs -f
}

function install_metals {
  install_metals_coursier && install_metals_emacs
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
