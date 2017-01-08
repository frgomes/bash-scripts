#!/bin/bash

DART_VERSION=1.21.0
DART_ARCH=linux-x64

   mkdir -p $HOME/Downloads && cd $HOME/Downloads \
&& wget http://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/dartsdk-${DART_ARCH}-release.zip \
&& wget http://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/dartium/dartium-${DART_ARCH}-release.zip \
&& wget http://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/api-docs/dartdocs-gen-api.zip \
&& mkdir -p /opt/developer && cd /opt/developer \
&& unzip $HOME/Downloads/dartsdk-${DART_ARCH}-release.zip \
&& unzip $HOME/Downloads/dartium-${DART_ARCH}-release.zip \
&& unzip $HOME/Downloads/dartdocs-gen-api.zip \
&& mv gen-dartdocs dartdocs
