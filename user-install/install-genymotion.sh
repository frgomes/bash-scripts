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
