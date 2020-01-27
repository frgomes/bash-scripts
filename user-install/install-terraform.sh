#!/bin/bash


function install_terraform_binaries {
  local version=${1:-"$TERRAFORM_VERSION"}
  local version=${version:-"0.12.20"}
  local arch=${1:-"$TERRAFORM_ARCH"}
  local arch=${arch:-"linux_amd64"}

  local file=terraform_${version}_${arch}.zip
  local url=https://releases.hashicorp.com/terraform/${version}/${file}
  local folder=terraform-${version}
  local symlink=terraform

  local tools=${TOOLS_HOME:=$HOME/tools}
  local Software=${SOFTWARE_HOME:=/mnt/omv/Software}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  [[ ! -d $tools ]] && mkdir -p $tools

  local archive=""
  if [[ -f ${Software}/Linux/${file} ]] ;then
    local archive=${Software}/Linux/${file}
  elif [[ -f ${HOME}/Downloads/${file} ]] ;then
    local archive=${HOME}/Downloads/${file}
  fi
  if [[ -z ${archive} ]] ;then
    local archive=${HOME}/Downloads/${file}
    wget "$url" -O "${archive}"
  fi

  if [ ! -d ${tools}/${folder} ] ;then
    mkdir -p ${tools}/${folder}
    unzip -d ${tools}/${folder} ${archive}
  fi
  if [ ! -z ${symlink} ] ;then
    if [ -L ${tools}/${symlink} ] ;then rm ${tools}/${symlink} ;fi
    ln -s ${folder} ${tools}/${symlink}
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/271-terraform.sh
#!/bin/bash

export TERRAFORM_VERSION=${version}
export TERRAFORM_HOME=\${TOOLS_HOME:=\$HOME/tools}/terraform-\${TERRAFORM_VERSION}

export PATH=\${TERRAFORM_HOME}:\${PATH}
EOD
}

function install_terraform {
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
