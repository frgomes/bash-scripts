#!/bin/bash


function install_genymotion {
  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads > /dev/null
  [[ ! -f genymotion-2.11.0-linux_x64.bin ]] \
    && wget https://www.genymotion.com/download-handler/?opt=ubu_first_64_download_link \
      && chmod 755 genymotion-2.11.0-linux_x64.bin
  popd > /dev/null

  ~/Downloads/genymotion-2.11.0-linux_x64.bin --destination ~/tools
}

install_genymotion
