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
  local self=$(readlink -f "${BASH_SOURCE[0]}")
  local dir=$(dirname $self)

  [[ -z $(which pip) ]] \
    && python3 -m pip install --upgrade pip

  [[ -z $(which virtualenv) ]] \
    && python3 -m pip install --upgrade virtualenv

  pushd $HOME > /dev/null
  virtualenv_profile_list | while read source ;do
    local envbin=$(dirname $source)
    local profile=$(basename $(dirname $envbin))
    if [ ! -f $HOME/.virtualenvs/${envbin}/python ] ;then
      echo "[Creating virtual environment ${profile}]"
      mkdir -p $HOME/.virtualenvs
      virtualenv -p /usr/bin/python3 $HOME/.virtualenvs/${profile}
      workon ${profile}
      ${dir}/user-install/install-python.sh
      deactivate
    fi
  done
  popd > /dev/null
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
