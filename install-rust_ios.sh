#!/bin/bash

set -x

work=$HOME/sources/github.com/rust-lang

mkdir -p $work && pushd $work

if [ -d rust ] ;then
  cd rust
  git pull
else
  git clone http://github.com/rust-lang/rust
  cd rust
fi

git checkout stable && git submodule update --init --recursive

git clean -d -x -f -f
git reset --hard

mkdir build && cd build

../configure --target=armv7-apple-ios,armv7s-apple-ios,i386-apple-ios,aarch64-apple-ios,x86_64-apple-ios --prefix=/opt/developer/rustc-ios

log="build_$(date +%Y%m%d_%H%M%S).log"

make clean
make -j4 > $log 2>&1  &&  make install > $log 2>&1

popd
