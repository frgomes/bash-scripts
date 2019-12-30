#!/bin/bash

function install_clang_repository {
sudo bash <<EOD
  echo "deb http://llvm.org/apt/jessie/     llvm-toolchain-jessie-3.8 main" >  /etc/apt/sources.list.d/llvm.list
  echo "deb-src http://llvm.org/apt/jessie/ llvm-toolchain-jessie-3.8 main" >> /etc/apt/sources.list.d/llvm.list
  wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | apt-key add -
EOD
}

function install_clang_binaries {
  local release=${1:-"stable"}
  local version=${2:-"3.8"}
  echo "Installing clang-${version} and llvm-${version} from ${release} ..."
  sudo apt install -t ${release} \
       clang-${version} clang-${version}-doc clang-format-${version} \
       llvm-${version} llvm-${version}-doc llvm-${version}-examples \
       lldb-${version}
  sudo rm /usr/bin/llvm-config
  sudo rm /usr/bin/clang
  sudo rm /usr/bin/clang++

  sudo ln -s /usr/bin/llvm-config-${version} /usr/bin/llvm-config
  sudo ln -s /usr/bin/clang-${version}       /usr/bin/clang
  sudo ln -s /usr/bin/clang++-${version}     /usr/bin/clang++
}

function install_clang {
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
