#!/bin/bash

source ~/scripts/bash_20functions.sh
not_installed qtbase5-dev && sudo apt install -y qtbase5-dev

[[ ! -d ~/workspace ]] && mkdir -p ~/workspace
pushd ~/workspace
[[ ! -d kio-gdrive ]] && git clone git://anongit.kde.org/kio-gdrive.git
cd kio-gdrive
git pull

[[ ! -d build ]] && mkdir build
cd build

## see: cmake-install.sh
cmake -DCMAKE_INSTALL_PREFIX=`qtpaths --install-prefix` ..

## sudo make install
## kdeinit5 # or just re-login

popd
