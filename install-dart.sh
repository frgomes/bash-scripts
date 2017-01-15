#!/bin/bash

DART_VERSION=${DART_VERSION:=1.21.1}
DART_ARCH=${DART_ARCH:=linux-x64}

# make sure all necessary tools are installed
if [ ! \( -e "$(which curl)" -a -e "$(which bsdtar)" \) ] ;then
  echo apt-get install curl bsdtar -y
  sudo apt-get install curl bsdtar -y
fi

mkdir -p /opt/developer && cd /opt/developer \
&& curl http://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/dartsdk-${DART_ARCH}-release.zip | bsdtar -xf - \
&& curl http://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/dartium/dartium-${DART_ARCH}-release.zip | bsdtar -xf - \
&& curl http://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/api-docs/dartdocs-gen-api.zip | bsdtar -xf - \
&& mv gen-dartdocs dartdocs
