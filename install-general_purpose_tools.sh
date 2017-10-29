#!/bin/bash


function install_general_purpose_tools {
  sudo apt-get install tar bsdtar bzip2 pbzip2 lbzip2 zstd lzip plzip xz-utils pxz pigz zip unzip p7zip p7zip-rar -y
  sudo apt-get install git gitk mercurial tortoisehg -y
  sudo apt-get install wget curl -y
  sudo apt-get install zile emacs25 -y
}


install_general_purpose_tools
