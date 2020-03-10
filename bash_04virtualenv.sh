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

  local __save=${dir}
  source ${dir}/user-install/install-python.sh > /dev/null
  local dir=${__save}

  echo ================ DIR $dir
  install_python_pip
  install_python_virtualenv

  pushd $HOME > /dev/null
  virtualenv_profile_list | while read source ;do
    local envbin=$(dirname $source)
    local profile=$(basename $(dirname $envbin))
    if [ ! -f $HOME/.virtualenvs/${envbin}/python ] ;then
      echo "[Creating virtual environment ${profile}]"
      mkdir -p $HOME/.virtualenvs
      case ${profile} in
        p2* ) virtualenv -p /usr/bin/python2 $HOME/.virtualenvs/${profile} ;;
        p3* ) virtualenv -p /usr/bin/python3 $HOME/.virtualenvs/${profile} ;;
        *   ) virtualenv -p /usr/bin/python3 $HOME/.virtualenvs/${profile} ;;
      esac

      local target=$HOME/.virtualenvs/${profile}/bin/postactivate
      if [ -L ${target} ] ;then
        rm ${target}
      elif [ -f ${target} ] ;then
        mv ${target} ${target}.${tstamp}
      fi
      ln -s ${dir}/bashrc-virtualenvs/${profile}/bin/postactivate ${target}
      set +x

      workon ${profile}
      source ${dir}/user-install/install-python.sh | while read cmd ;do ${cmd} ;done
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

virtualenv_make_virtualenvs # && virtualenv_profile_link_all
