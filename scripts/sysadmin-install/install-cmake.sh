#!/bin/bash

set -x

## download
mkdir $HOME/Downloads
pushd $HOME/Downloads
wget https://cmake.org/files/v3.11/cmake-3.11.1.tar.gz
popd

## build
mkdir $HOME/workspace
pushd $HOME/workspace
tar xpf $HOME/Downloads/cmake-3.11.1.tar.gz
cd cmake-3.11.1
./bootstrap
make

## make sure CMake is remove from the system
source ~/scripts/bash_20functions.sh
installed cmake && apt-get remove --purge cmake cmake-data -y

## install
sudo make install

popd
