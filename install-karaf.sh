#!/bin/bash

_V=1
source ~/bin/bash_21functions.sh

KARAF_VERSION=4.0.0.M3


#
# Downloading...
#
_info Downloading Apache Karaf...
download http://apache.claz.org/karaf/${KARAF_VERSION}/apache-karaf-${KARAF_VERSION}.tar.gz

download http://apache.claz.org/cxf/3.1.1/apache-cxf-3.1.1.tar.gz
# feature:install cxf-dosgi-ri-discovery-distributed

_info Installing Apache Karaf
pushd /opt/developer
if [ ! -d apache-karaf-${KARAF_VERSION} ] ;then
  tar xpf $HOME/Downloads/apache-karaf-${KARAF_VERSION}.tar.gz
fi
popd
