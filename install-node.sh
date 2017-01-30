#!/bin/bash

NODE_VERSION=${NODE_VERSION:=7.4.0}
NODE_ARCH=${NODE_ARCH:=linux-x64}

# make sure all necessary tools are installed
if [ ! \( -e "$(which curl)" -a -e "$(which bsdtar)" \) ] ;then
  echo apt-get install curl bsdtar -y
  sudo apt-get install curl bsdtar -y
fi

mkdir -p /opt/developer && cd /opt/developer \
&& curl http://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-${NODE_ARCH}.tar.xz | bsdtar -xf - \
&& /opt/developer/node-v${NODE_VERSION}-${NODE_ARCH}/bin/npm install yarn -g --save \
&& /opt/developer/node-v${NODE_VERSION}-${NODE_ARCH}/bin/yarn global add typescript typings \
&& /opt/developer/node-v${NODE_VERSION}-${NODE_ARCH}/bin/yarn global add angular-cli \
&& /opt/developer/node-v${NODE_VERSION}-${NODE_ARCH}/bin/yarn global add typescript@2.0.3 typings@2.1.0 tslint@4.4.2 \
&& /opt/developer/node-v${NODE_VERSION}-${NODE_ARCH}/bin/yarn global add gulp@3.9.1
