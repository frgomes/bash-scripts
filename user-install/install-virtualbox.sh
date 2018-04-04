#!/bin/bash


function install_virtualbox_working_folder {
  [[ ! -d /srv/lib/virtualbox ]] && sudo mkdir -p /srv/lib/virtualbox
  [[ ! -d /var/lib/virtualbox ]] && sudo ln -s /srv/lib/virtualbox /var/lib/virtualbox
} 

function install_virtualbox {
  local version=${1}
  local version=${version:=5.2}

  sudo apt-get install lsb-release apt-transport-https dirmngr -y

  release=$(lsb_release -cs)
  echo deb http://download.virtualbox.org/virtualbox/debian ${release} contrib | sudo tee /etc/apt/sources.list.d/virtualbox.list
  curl https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -

  sudo apt-get update
  sudo apt-get install virtualbox-${version}

  sudo usermod -a -G vboxusers $USER
}


## install_virtualbox_working_folder && 
install_virtualbox
