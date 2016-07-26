#!/bin/bash

function dpkg_list() {
  dpkg --list | grep -E '^rc' | awk '{ print $2 }'
}

function dpkg_purge() {
  for pkg in `dpkg --list | grep -E '^rc' | awk '{ print $2 }' ` ;do
    sudo dpkg --purge $pkg
  done
}
