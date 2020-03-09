#!/bin/bash


function install_riot_repository {
sudo bash <<EOD
  echo "deb https://riot.im/packages/debian/ sid main" > /etc/apt/sources.list.d/matrix-riot-im.list
  wget -O - https://riot.im/packages/debian/repo-key.asc | sudo apt-key add -
EOD
}

function install_riot_binaries {
  sudo apt update && sudo apt install -y riot-web 
}

function install_riot {
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
