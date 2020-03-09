#!/bin/bash -x

function install_mozilla_sops_binaries {
  local version=${SOPS_VERSION:=3.5.0}
  local file=sops_${SOPS_VERSION}_amd64.deb
  local url=https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/${file}

  local Software=${SOFTWARE_HOME:=/mnt/omv/Software}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads

  local archive=""
  if [[ -f ${Software}/Linux/Debian/${file} ]] ;then
    local archive=${Software}/Linux/Debian/${file}
  elif [[ -f ${HOME}/Downloads/${file} ]] ;then
    local archive=${HOME}/Downloads/${file}
  fi
  if [[ -z ${archive} ]] ;then
    local archive=${HOME}/Downloads/${file}
    wget "$url" -O "${archive}"
  fi

  sudo apt install -y ${archive}
}

function install_mozilla_sops {
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
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
