#!/bin/bash


function install_tools_compression {
  sudo apt-get install tar bsdtar bzip2 pbzip2 lbzip2 zstd lzip plzip xz-utils pxz pigz zip unzip p7zip p7zip-rar -y
  [[ ! -e /usr/local/bin/bzip2   ]] && sudo ln -s /usr/bin/lbzip2 /usr/local/bin/bzip2
  [[ ! -e /usr/local/bin/bunzip2 ]] && sudo ln -s /usr/bin/lbzip2 /usr/local/bin/bunzip2
  [[ ! -e /usr/local/bin/bzcat   ]] && sudo ln -s /usr/bin/lbzip2 /usr/local/bin/bzcat
  [[ ! -e /usr/local/bin/gzip    ]] && sudo ln -s /usr/bin/pigz   /usr/local/bin/gzip
  [[ ! -e /usr/local/bin/gunzip  ]] && sudo ln -s /usr/bin/pigz   /usr/local/bin/gunzip
  [[ ! -e /usr/local/bin/gzcat   ]] && sudo ln -s /usr/bin/pigz   /usr/local/bin/gzcat
  [[ ! -e /usr/local/bin/lzip    ]] && sudo ln -s /usr/bin/plzip  /usr/local/bin/lzip
  [[ ! -e /usr/local/bin/xz      ]] && sudo ln -s /usr/bin/pxz    /usr/local/bin/xz
}

function install_tools_scm {
  sudo apt-get install git gitk mercurial tortoisehg -y
}

function install_tools_downloads {
  sudo apt-get install wget curl -y
}

function install_tools_editors {
  sudo apt-get install zile emacs25 -y
}

function install_tools_parallelism {
  sudo apt-get install parallel -y
}


install_tools_compression
install_tools_scm
install_tools_downloads
install_tools_editors
install_tools_parallelism
