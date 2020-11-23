#!/bin/bash


function install_virtualbox_working_folder {
  [[ ! -d /srv/lib/virtualbox ]] && sudo mkdir -p /srv/lib/virtualbox
  [[ ! -d /var/lib/virtualbox ]] && sudo ln -s /srv/lib/virtualbox /var/lib/virtualbox
} 

function install_virtualbox_binaries {
  local version=${1}
  local version=${version:=5.2}

  sudo aptitude install -y lsb-release apt-transport-https dirmngr

  release=$(lsb_release -cs)
  echo deb http://download.virtualbox.org/virtualbox/debian ${release} contrib | sudo tee /etc/apt/sources.list.d/virtualbox.list
  curl https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -

  sudo aptitude update
  sudo aptitude install -y virtualbox-${version}

  sudo usermod -a -G vboxusers $USER
}


function install_virtualbox {
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
