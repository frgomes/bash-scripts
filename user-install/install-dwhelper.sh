#!/bin/bash -eu


function install_dwhelper_binaries {
  local version=${1:-"$DWHELPER_VERSION"}
  local version=${version:-"1.3.0-1"}
  local semver=$(echo $version | cut -d- -f1)

  local machine=$(uname -m | tr '[:upper:]' '[:lower:]'))
  case "${machine}" in
    armv7l)
      local arch=arm
        ;;
    *)
      local arch=amd64
        ;;
  esac

  local tools=${TOOLS_HOME:=$HOME/tools}
  local Software="${SOFTWARE:=/mnt/omv/Software}"
  
  local file=net.downloadhelper.coapp-${version}_${arch}.tar.gz
  local url=https://github.com/mi-g/vdhcoapp/releases/download/v${semver}/${file}
  local folder=${tools}/net.downloadhelper.coapp-${semver}
  local symlink=${HOME}/net.downloadhelper.coapp-${semver}

  [[ ! -d "${DOWNLOADS}" ]] && mkdir -p "${DOWNLOADS}"
  [[ ! -d $tools ]] && mkdir -p $tools

  local archive=""
  if [[ -f ${Software}/Linux/${file} ]] ;then
    local archive=${Software}/Linux/${file}
  elif [[ -f "${DOWNLOADS}"/${file} ]] ;then
    local archive="${DOWNLOADS}"/${file}
  fi
  if [[ -z ${archive} ]] ;then
    local archive="${DOWNLOADS}"/${file}
    wget "$url" -O "${archive}"
  fi

  if [ ! -d ${folder} ] ;then
    mkdir -p ${folder}
    tar -C ${folder} --strip-components 1 -eupf ${archive}
  fi
  if [ ! -z ${symlink} ] ;then
    if [ -L ${tools}/${symlink} ] ;then rm ${tools}/${symlink} ;fi
    ln -s ${folder} ${tools}/${symlink}
    ${symlink}/bin/net.downloadhelper.coapp-linux-64 install --user
  fi
}

function install_dwhelper {
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
