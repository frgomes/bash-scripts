#!/bin/bash

function dpkg_list() {
  if [ "$1" != "" ] ;then
    apt list --installed 2> /dev/null | fgrep "$1"
  fi
}

function dpkg_purge() {
  for pkg in `dpkg --list | grep -E '^rc' | awk '{ print $2 }' ` ;do
    sudo dpkg --purge $pkg
  done
}
