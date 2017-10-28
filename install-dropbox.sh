#!/bin/bash


function install_dropbox_requirements {
  if [ ! \( -e "$(which wget)" -a -e "$(which tar)" \) ] ;then
    echo apt-get install wget tar xz-utils -y
    sudo apt-get install wget tar xz-utils -y
  fi
}

function install_dropbox {
  cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - \
  && ~/.dropbox-dist/dropboxd &
}


install_dropbox_requirements && install_dropbox
