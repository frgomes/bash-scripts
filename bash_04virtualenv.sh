#!/bin/bash


# List profiles
function virtualenv_profile_list {
  local self=$(readlink -f "${BASH_SOURCE[0]}")
  local dir=$(dirname $self)
  if [ -d ${dir}/bashrc-virtualenvs ] ;then
    pushd ${dir}/bashrc-virtualenvs > /dev/null
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
           python${v} -m pip install --upgrade pip
           python${v} -m pip install --upgrade pylint pyflakes
           python${v} -m pip install --upgrade python-language-server[all]
           python${v} -m pip install --upgrade python-language-server[all]
           python${v} -m pip install --upgrade cmake-language-server
           python${v} -m pip install --upgrade fortran-language-server
           python${v} -m pip install --upgrade hdl-checker upgrade
    fi
  done
}

# Link virtualenvs to corresponding profiles, if possible, if needed.
function virtualenv_profile_link_all {
  local self=$(readlink -f "${BASH_SOURCE[0]}")
  local dir=$(dirname $self)
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
    ln -s ${dir}/bashrc-virtualenvs/${source} ${target}
  done
}

virtualenv_make_virtualenvs && virtualenv_profile_link_all
