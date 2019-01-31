#!/bin/bash


function install_fonts_monospaced {
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
  # echo $cmd
  $cmd $*
fi
