#!/bin/bash

export TOOLS_HOME=${TOOLS_HOME:=$HOME/tools}

source /etc/os-release
case "$ID" in
  debian) alias apt='/usr/bin/apt' ;;
  ubuntu) alias apt='/usr/bin/apt' ;;
  centos) alias apt='/usr/bin/yum' ;;
  fedora) alias apt='/usr/bin/yum' ;;
  *)      alias apt='/usr/bin/apt' ;;
esac
