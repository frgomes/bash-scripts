#!/bin/bash

function _cscope() {
  local cur prev opts base
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts=""

  local projects=$( ls -p ~/cscope | fgrep / | sed 's:/::' )
  COMPREPLY=( $(compgen -W "${projects}" -- ${cur}) )
  return 0
}


complete -F _cscope cscope+
