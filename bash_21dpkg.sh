#!/bin/bash

function dpkg_list() {
  if [ "$1" != "" ] ;then
    apt list --installed 2> /dev/null | fgrep "$1"
  fi
}
