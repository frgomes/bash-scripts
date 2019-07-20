#!/bin/bash

function install_pgadmin4 {
  sudo apt-get install curl ca-certificates gnupg
  curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

  local release=$(lsb_release -c -s)
  echo "deb http://apt.postgresql.org/pub/repos/apt/ ${release}-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
  sudo apt update
  sudo apt install pgadmin4
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
