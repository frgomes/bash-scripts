#!/bin/bash


# List profiles made available by debian-bin
function virtualenv_profile_list {
  if [ -d $HOME/bin/virtualenvs ] ;then
    pushd $HOME/bin/virtualenvs > /dev/null
    find . -type f -name postactivate
    popd > /dev/null
  fi
}


# Link virtualenvs to corresponding profiles, if possible, if needed.
function virtualenv_profile_relink_all {
  local tstamp=$(date +%Y%m%d%H%M%S)
  virtualenv_profile_list | while read source ;do
    local target=$HOME/.virtualenvs/${source}
    if [ -f ${target} ] ;then
      mv ${target} ${target}.${tstamp}
      ln -s $HOME/bin/virtualenvs/${source} ${target}
    fi
  done
}


virtualenv_profile_relink_all
