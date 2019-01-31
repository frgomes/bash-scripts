#!/bin/bash


function install_riot_repository() {
sudo bash <<EOD
  echo "deb https://riot.im/packages/debian/ sid main" > /etc/apt/sources.list.d/matrix-riot-im.list
  wget -O - https://riot.im/packages/debian/repo-key.asc | sudo apt-key add -
EOD
}

function install_riot_binaries() {
  sudo apt update && sudo apt install -y riot-web 
}

function install_riot {
    install_riot_repository && install_riot_binaries
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
