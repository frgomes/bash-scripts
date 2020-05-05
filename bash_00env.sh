#!/bin/bash

export DOWNLOADS="${DOWNLOADS:=${HOME}/Downloads}"
export DOCUMENTS="${DOCUMENTS:=${HOME}/Documents}"
export MEDIA="${MEDIA:=${HOME}/Media}"

export SOFTWARE="/mnt/omv/Software"
export WORKSPACE="${WORKSPACE:=${HOME}/workspace}"
export WORKON_HOME="${WORKON_HOME:=${HOME}/.virtualenvs}"
export TOOLS_HOME="${TOOLS_HOME:=$HOME/tools}"

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
