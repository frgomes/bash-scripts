#!/bin/bash


function install_wp34s {

  # make sure all necessary tools are installed
  if [ ! \( -e "$(which wget)" -a -e "$(which bsdtar)" \) ] ;then
    echo apt-get install wget bsdtar xz-utils -y
    sudo apt-get install wget bsdtar xz-utils -y
  fi

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f wp-34s-emulator-linux64.tgz ]] \
    && wget https://downloads.sourceforge.net/project/wp34s/emulator/wp-34s-emulator-linux64.tgz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fwp34s%2Ffiles%2Femulator%2F&ts=1509137814&use_mirror=netcologne
  popd
  
  [[ ! -d /opt/wp-34s ]] && sudo mkdir -p /opt/wp-34s
  pushd /opt \
    && sudo bsdtar -xf ~/Downloads/wp-34s-emulator-linux64.tgz \
    && sudo ln -s /opt/wp-34s/WP-34s    /usr/local/bin \
    && sudo ln -s /opt/wp-34s/HP-82240B /usr/local/bin

  echo /usr/local/bin/WP-34S
  echo /usr/local/bin/HP-82240B
}


install_wp34s
