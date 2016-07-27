#!/bin/bash

if [ -d ~/Development/repository ] ;then
  function branch() {
    local dir=$1
    local dir=${dir:=Trunk}
    if [ -d ~/Development/repository/${dir} ] ;then
      cd ~/Development/repository/${dir}
      if [ -f Star5/star_functions.sh ] ;then
        source Star5/star_functions.sh
      fi
    fi
  }
fi
