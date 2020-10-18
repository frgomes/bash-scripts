#!/bin/bash

## A minimal Python installation should be available in your distribution in general.
## However, we simply skip this entire business in case Python is missing.

function install_python_pip {
  if [[ ! -z $(which python) ]] ;then
    if [[ ! -e "${HOME}/.local/bin/pip" ]] ;then
      [[ ! -d "${DOWNLOADS}" ]] && mkdir -p "${DOWNLOADS}"
      [[ ! -f "${DOWNLOADS}/get-pip.py" ]] && wget https://bootstrap.pypa.io/get-pip.py -O "${DOWNLOADS}/get-pip.py"
   
      local -i v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
      if [ -e $(which python${v}) ] ;then
        python${v} "${DOWNLOADS}/get-pip.py"
      fi
    fi
  fi
}

function __install_python_virtualenv {
  if [[ ! -z $(which python) ]] ;then
    local -i v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
    if [ -e $(which python${v}) ] ;then
      python${v} -m pip install --quiet --user --upgrade pip virtualenv virtualenvwrapper
    fi
  fi
   
  [[ -e "${HOME}/.local/bin/virtualenvwrapper.sh" ]] && source "${HOME}/.local/bin/virtualenvwrapper.sh"
  if [ -d "${HOME}/.local/bin" ] ;then
    [[ ! $(echo ${PATH} | tr ':' '\n' | fgrep "${HOME}/.local/bin") ]] && export PATH="${HOME}/.local/bin":"${PATH}"
  fi
}

function install_python_install_packages {
  local -i v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
  for module in mercurial oyaml ;do
    python${v} -m pip install --upgrade ${module}
  done
}

function install_python_LSP_support {
  local v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
  if [ "${v}" == "3" ] ;then
    for module in pylint pyflakes python-language-server[all] ;do
      python${v} -m pip install --upgrade ${module}
    done
  fi
}

function install_python_LSP_optional_cmake {
  local v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
  if [ "${v}" == "3" ] ;then
    for module in pip pylint pyflakes python-language-server[all] cmake-language-server ;do
      python${v} -m pip install --upgrade ${module}
    done
  fi
}

function install_python_LSP_optional_fortran {
  local v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
  if [ "${v}" == "3" ] ;then
    for module in pip pylint pyflakes python-language-server[all] fortran-language-server ;do
      python${v} -m pip install --upgrade ${module}
    done
  fi
}

function install_python_LSP_optional_hdl {
  local v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
  if [ "${v}" == "3" ] ;then
    for module in pip pylint pyflakes python-language-server[all] hdl-checker ;do
      python${v} -m pip install --upgrade ${module}
    done
  fi
}

function install_python {
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | fgrep -v LSP_optional | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd $*
  done
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(grep -E "^function " $self | cut -d' ' -f2 | tail -1)
  $cmd $*
fi
