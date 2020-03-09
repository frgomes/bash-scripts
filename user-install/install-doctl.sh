#!/bin/bash -x

function install_doctl_cli_binaries {
  local version=${1:-"$DOCTL_VERSION"}
  local version=${version:-"1.38.0"}

  local arch=${2:-"$DOCTL_ARCH"}
  local arch=${arch:-"linux-amd64"}

  local file=doctl-${version}-${arch}.tar.gz
  local url=https://github.com/digitalocean/doctl/releases/download/v${version}/${file}
  local folder=doctl-v${version}-${arch}
  local symlink=doctl
  
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
    ##XXX tar -C ${tools}/${folder} --strip-components 1 -xpf ${archive}
    tar -C ${tools}/${folder} -xpf ${archive}
  fi
  if [ ! -z ${symlink} ] ;then
    if [ -L ${tools}/${symlink} ] ;then rm ${tools}/${symlink} ;fi
    ln -s ${folder} ${tools}/${symlink}
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/271-doctl.sh
#!/bin/bash

export DOCTL_VERSION=${version}
export DOCTL_ARCH=\${DOCTL_ARCH:-linux-amd64}
export DOCTL_HOME=\${TOOLS_HOME:=\$HOME/tools}/doctl-v\${DOCTL_VERSION}-\${DOCTL_ARCH}

export PATH=\${DOCTL_HOME}:\${PATH}
EOD
}


function install_doctl_cli {
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
