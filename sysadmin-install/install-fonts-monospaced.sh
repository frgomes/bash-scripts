#!/bin/bash


function install_fonts_monospaced_binaries {
    sudo apt install -y \
         fonts-3270 \
         fonts-fantasque-sans \
         fonts-inconsolata \
         fonts-ricty-diminished \
         fonts-hack-otf \
         xfonts-terminus \
         xfonts-traditional \
         fonts-firacode \
         fonts-jura \
         fonts-noto-mono
}

function install_fonts_monospaced {
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
