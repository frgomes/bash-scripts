#!/bin/bash

function install_pgadmin4_binaries {
  sudo apt-get install curl ca-certificates gnupg
  curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

  local release=$(lsb_release -c -s)
  echo "deb http://apt.postgresql.org/pub/repos/apt/ ${release}-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
  sudo apt update
  sudo apt install pgadmin4
}

function install_pgadmin4 {
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd $*
  done
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(grep -E "^function " $self | cut -d' ' -f2 | tail -1)
  $cmd $*
fi
