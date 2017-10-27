#!/bin/bash


function install_wp34s_requirements {
  if [ ! \( -e "$(which wget)" -a -e "$(which bsdtar)" \) ] ;then
    echo apt-get install wget bsdtar xz-utils -y
    sudo apt-get install wget bsdtar xz-utils -y
  fi
}

function install_wp34s_download {
  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f wp-34s-emulator-linux64.tgz ]] \
    && wget -O ~/Downloads/wp-34s-emulator-linux64.tgz https://downloads.sourceforge.net/project/wp34s/emulator/wp-34s-emulator-linux64.tgz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fwp34s%2Ffiles%2Femulator%2F&ts=1509137814&use_mirror=netcologne
  popd
}

function install_wp34s {
  if [ -f ~/Downloads/wp-34s-emulator-linux64.tgz ] ;then
    [[ ! -d /opt ]] && sudo mkdir -p /opt
    pushd /opt
    sudo tar -xf ~/Downloads/wp-34s-emulator-linux64.tgz \
    && sudo ln -s /opt/wp-34s/WP-34s    /usr/local/bin \
    && sudo ln -s /opt/wp-34s/HP-82240B /usr/local/bin \
    && echo /usr/local/bin/WP-34S \
    && echo /usr/local/bin/HP-82240B
    popd
  fi
}


install_wp34s_requirements && install_wp34s_download && install_wp34s

