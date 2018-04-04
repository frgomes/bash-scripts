#!/bin/bash

set -x

## download
mkdir $HOME/Downloads
pushd $HOME/Downloads
wget https://cmake.org/files/v3.5/cmake-3.5.2.tar.gz
popd

## build
mkdir $HOME/workspace
pushd $HOME/workspace
tar xpf $HOME/Downloads/cmake-3.5.2.tar.gz
cd cmake-3.5.2
./bootstrap
make

## make sure CMake is remove from the system
apt-get remove --purge cmake cmake-data -y

## install
sudo make install

popd
