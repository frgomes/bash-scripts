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

  function _star_complete_branch() {
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=""

    local branches=$( ls -p ~/Development/repository | fgrep / | sed 's:/::' )
    COMPREPLY=( $(compgen -W "${branches}" -- ${cur}) )
    return 0
  }
  complete -F _star_complete_branch branch

  # autoload utility functions if activated from a branch
  for script in $(pwd)/Star5/star_functions.sh $(pwd)/Star5/hghelper.sh ;do
    if [ -f $script ] ;then source $script ;fi
  done

fi
