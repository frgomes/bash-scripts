#!/bin/bash

## A minimal Python installation should be available in your distribution in general.
## However, we simply skip this entire business in case Python is missing.

function virtualenv_install_pip {
  if [[ ! -z $(which python) ]] ;then
    if [[ ! -e "${HOME}/.local/bin/pip" ]] ;then
      [[ ! -d "${DOWNLOADS}" ]] && mkdir -p "${DOWNLOADS}"
      [[ ! -f "${DOWNLOADS}/get-pip.py" ]] && wget https://bootstrap.pypa.io/get-pip.py -O "${DOWNLOADS}/get-pip.py"
   
      local -i v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
      if [ -e $(which python${v}) ] ;then
        python${v} "${DOWNLOADS}/get-pip.py" --user
      fi
    fi
  fi
}

function virtualenv_install_virtualenv {
  if [[ ! -z $(which python) ]] ;then
    local -i v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
    if [ -e $(which python${v}) ] ;then
      python${v} -m pip install --quiet --user --upgrade pip virtualenv virtualenvwrapper
    fi
  fi
  [[ -e "${HOME}/.local/bin/virtualenvwrapper.sh" ]] && source "${HOME}/.local/bin/virtualenvwrapper.sh"
}

virtualenv_install_pip
virtualenv_install_virtualenv
