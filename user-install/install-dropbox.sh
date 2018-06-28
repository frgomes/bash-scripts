#!/bin/bash


function install_dropbox {
  cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - \
  && ~/.dropbox-dist/dropboxd &
}


install_dropbox
