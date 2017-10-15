#!/bin/bash

function apt_install_no_prompt {
  if [ ! -z "$1" ] ;then
    ! $(dpkg -s "$1" > /dev/null 2>&1) && sudo apt-get install --reinstall -y "$1"
  fi
}
