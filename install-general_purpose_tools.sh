#!/bin/bash


function install_general_purpose_tools {
  sudo apt-get install tar bsdtar bzip2 pbzip2 xz-utils pixz zip unzip plzip p7zip p7zip-rar -y
  sudo apt-get install git gitk mercurial tortoisehg -y
  sudo apt-get install wget curl -y
  sudo apt-get install zile emacs25 -y
}


install_general_purpose_tools
