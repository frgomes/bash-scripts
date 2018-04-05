#!/bin/bash


# List profiles made available by debian-bin
function virtualenv_profile_list {
  if [ -d $HOME/scripts/bashrc-virtualenvs ] ;then
    pushd $HOME/scripts/bashrc-virtualenvs > /dev/null
    find . -type f -name postactivate
    popd > /dev/null
  fi
}


# Link virtualenvs to corresponding profiles, if possible, if needed.
function virtualenv_profile_link_all {
  local tstamp=$(date +%Y%m%d%H%M%S)
  virtualenv_profile_list | while read source ;do
    local envbin=$(dirname $source)
    mkdir -p $HOME/.virtualenvs/${envbin} > /dev/null 2>&1
    local target=$HOME/.virtualenvs/${source}
    if [ -L ${target} ] ;then
      rm ${target}
    elif [ -f ${target} ] ;then
      mv ${target} ${target}.${tstamp}
    fi
    ln -s $HOME/scripts/bashrc-virtualenvs/${source} ${target}
  done
}

virtualenv_profile_link_all
