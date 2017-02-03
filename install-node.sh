#!/bin/bash

NODE_VERSION=${NODE_VERSION:=4.7.3}
NODE_ARCH=${NODE_ARCH:=linux-x64}

# make sure all necessary tools are installed
if [ ! \( -e "$(which curl)" -a -e "$(which bsdtar)" \) ] ;then
  echo apt-get install curl bsdtar -y
  sudo apt-get install curl bsdtar -y
fi

mkdir -p /opt/developer && cd /opt/developer \
&& curl http://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-${NODE_ARCH}.tar.xz | bsdtar -xf -
