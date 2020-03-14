#!/bin/bash

export TOOLS_HOME=${TOOLS_HOME:=$HOME/tools}

source /etc/os-release
case "$ID" in
  debian) alias apt='apt' ;;
  ubuntu) alias apt='apt' ;;
  centos) alias apt='yum' ;;
  fedora) alias apt='yum' ;;
  *)      alias apt='apt' ;;
esac

function installed {
  dpkg -s "$1" > /dev/null 2>&1
}

function uninstalled {
  installed "$1" && return 1
  return 0
}
