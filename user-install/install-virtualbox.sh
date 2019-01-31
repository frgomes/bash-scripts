#!/bin/bash


function install_virtualbox_working_folder {
  [[ ! -d /srv/lib/virtualbox ]] && sudo mkdir -p /srv/lib/virtualbox
  [[ ! -d /var/lib/virtualbox ]] && sudo ln -s /srv/lib/virtualbox /var/lib/virtualbox
} 

function install_virtualbox_binaries {
  local version=${1}
  local version=${version:=5.2}

  sudo apt install lsb-release apt-transport-https dirmngr -y

  release=$(lsb_release -cs)
  echo deb http://download.virtualbox.org/virtualbox/debian ${release} contrib | sudo tee /etc/apt/sources.list.d/virtualbox.list
  curl https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -

  sudo apt update
  sudo apt install virtualbox-${version}

  sudo usermod -a -G vboxusers $USER
}


function install_virtualbox {
    install_virtualbox_working_folder && install_virtualbox_binaries
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
  echo $cmd
  $cmd
fi
