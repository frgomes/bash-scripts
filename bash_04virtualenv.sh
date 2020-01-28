#!/bin/bash


# List profiles
function virtualenv_profile_list {
  if [ -d $HOME/scripts/bashrc-virtualenvs ] ;then
    pushd $HOME/scripts/bashrc-virtualenvs > /dev/null
    find . -type f -name postactivate
    popd > /dev/null
  fi
}

function virtualenv_make_virtualenvs {
  virtualenv_profile_list | while read source ;do
    local envbin=$(dirname $source)
    local profile=$(dirname $envbin)
    local v=3
    if [ ! -f $HOME/.virtualenvs/${envbin}/python ] ;then
           mkvirtualenv -p /usr/bin/python${v} ${profile}
           pip${v} install --upgrade pip
           pip${v} install --upgrade pylint pyflakes
           pip${v} install --upgrade python-language-server[all]
    fi
  done
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

virtualenv_make_virtualenvs && virtualenv_profile_link_all
