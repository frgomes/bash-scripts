#!/bin/bash -x


function install_helm_binaries {
  local version=${1:-"$HELM_VERSION"}
  local version=${version:-"3.1.1"}
  local arch=${2:-"$HELM_ARCH"}
  local arch=${arch:-"linux-amd64"}

  local file=helm-v${version}-${arch}.tar.gz
  local url=https://get.helm.sh/${file}
  local folder=helm-${version}
  local symlink=helm

  local tools=${TOOLS_HOME:=$HOME/tools}
  local Software="${SOFTWARE:=/mnt/omv/Software}"

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

  if [ ! -d ${tools}/${folder} ] ;then
    mkdir -p ${tools}/${folder}
    tar -C ${tools}/${folder} -xpf ${archive}
  fi
  if [ ! -z ${symlink} ] ;then
    if [ -L ${tools}/${symlink} ] ;then rm ${tools}/${symlink} ;fi
    ln -s ${folder} ${tools}/${symlink}
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/271-helm.sh
#!/bin/bash

export HELM_VERSION=${version}
export HELM_ARCH=${arch}
export HELM_HOME=\${TOOLS_HOME:=\$HOME/tools}/helm-\${HELM_VERSION}

export PATH=\${HELM_HOME}/\${HELM_ARCH}:\${PATH}
EOD
}

function install_helm_repository {
  source ${HOME}/.bashrc-scripts/installed/271-helm.sh
  helm repo add jetstack https://charts.jetstack.io
  helm repo update
}

function install_helm {
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
