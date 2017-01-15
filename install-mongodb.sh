#!/bin/bash

MONGO_VERSION=${MONGO_VERSION:=3.4.1}
MONGO_ARCH=${MONGO_ARCH:=linux-x86_64}
MONGO_OS=${MONGO_OS:=debian81}

# make sure all necessary tools are installed
if [ ! \( -e "$(which curl)" -a -e "$(which bsdtar)" \) ] ;then
  echo apt-get install curl bsdtar -y
  sudo apt-get install curl bsdtar -y
fi

mkdir -p /opt/developer && cd /opt/developer \
&& curl https://fastdl.mongodb.org/linux/mongodb-${MONGO_ARCH}-${MONGO_OS}-${MONGO_VERSION}.tgz | bsdtar -xf -
