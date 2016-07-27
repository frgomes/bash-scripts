#!/bin/bash

if [ -d ~/Development/repository ] ;then

  function branch() {
    local dir=$1
    local dir=${dir:=Trunk}
    if [ -d ~/Development/repository/${dir} ] ;then
      # change directory to requested branch
      cd ~/Development/repository/${dir}
      # autoload utility functions
      if [ -f $(pwd)/Star5/star_functions.sh ] ;then
        source $(pwd)/Star5/star_functions.sh
      fi
    fi
  }

  # autoload utility functions if activated from a branch
  if [ -f $(pwd)/Star5/star_functions.sh ] ;then
    source $(pwd)/Star5/star_functions.sh
  fi

fi
