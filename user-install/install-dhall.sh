#!/bin/bash -x


function install_dhall_compiler_binaries {
  local version=${1:-"$DHALL_VERSION"}
  local version=${version:-"1.31.1"}

  local arch=${2:-"$DHALL_ARCH"}
  local arch=${arch:-"x86_64-linux"}

  local file=dhall-${version}-${arch}.tar.bz2
  local url=https://github.com/dhall-lang/dhall-haskell/releases/download/${version}/${file}
  local folder=dhall-v${version}-${arch}
  local symlink=dhall
  
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

  ##XXX if [ ! -d ${tools}/${folder} ] ;then
    mkdir -p ${tools}/${folder}
    ##XXX tar -C ${tools}/${folder} --strip-components 1 -xpf ${archive}
    tar -C ${tools}/${folder} -xpf ${archive}
  ##XXX fi
  if [ ! -z ${symlink} ] ;then
    if [ -L ${tools}/${symlink} ] ;then rm ${tools}/${symlink} ;fi
    ln -s ${folder} ${tools}/${symlink}
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/271-dhall.sh
#!/bin/bash

export DHALL_VERSION=${version}
export DHALL_ARCH=\${DHALL_ARCH:-x86_64-linux}
export DHALL_HOME=\${TOOLS_HOME:=\$HOME/tools}/dhall-v\${DHALL_VERSION}-\${DHALL_ARCH}/bin

export PATH=\${DHALL_HOME}:\${PATH}
EOD
}

function install_dhall_lsp_binaries {
  local version=${1:-"$DHALL_VERSION"}
  local version=${version:-"1.31.1"}

  local arch=${2:-"$DHALL_ARCH"}
  local arch=${arch:-"x86_64-linux"}

  local vtool=${3:-"$DHALL_LSP_VERSION"}
  local vtool=${vtool:-"1.0.6"}

  local file=dhall-lsp-server-${vtool}-${arch}.tar.bz2
  local url=https://github.com/dhall-lang/dhall-haskell/releases/download/${version}/${file}
  local folder=dhall-v${version}-${arch}
  local symlink=dhall
  
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

  ##XXX if [ ! -d ${tools}/${folder} ] ;then
    mkdir -p ${tools}/${folder}
    ##XXX tar -C ${tools}/${folder} --strip-components 1 -xpf ${archive}
    tar -C ${tools}/${folder} -xpf ${archive}
  ##XXX fi
  if [ ! -z ${symlink} ] ;then
    if [ -L ${tools}/${symlink} ] ;then rm ${tools}/${symlink} ;fi
    ln -s ${folder} ${tools}/${symlink}
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/271-dhall.sh
#!/bin/bash

export DHALL_VERSION=${version}
export DHALL_JSON_VERSION=${vtool}
export DHALL_ARCH=\${DHALL_ARCH:-x86_64-linux}
export DHALL_HOME=\${TOOLS_HOME:=\$HOME/tools}/dhall-v\${DHALL_VERSION}-\${DHALL_ARCH}/bin

export PATH=\${DHALL_HOME}:\${PATH}
EOD
}

function install_dhall_json_binaries {
  local version=${1:-"$DHALL_VERSION"}
  local version=${version:-"1.31.1"}

  local arch=${2:-"$DHALL_ARCH"}
  local arch=${arch:-"x86_64-linux"}

  local vtool=${3:-"$DHALL_JSON_VERSION"}
  local vtool=${vtool:-"1.6.3"}

  local file=dhall-json-${vtool}-${arch}.tar.bz2
  local url=https://github.com/dhall-lang/dhall-haskell/releases/download/${version}/${file}
  local folder=dhall-v${version}-${arch}
  local symlink=dhall
  
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

  ##XXX if [ ! -d ${tools}/${folder} ] ;then
    mkdir -p ${tools}/${folder}
    ##XXX tar -C ${tools}/${folder} --strip-components 1 -xpf ${archive}
    tar -C ${tools}/${folder} -xpf ${archive}
  ##XXX fi
  if [ ! -z ${symlink} ] ;then
    if [ -L ${tools}/${symlink} ] ;then rm ${tools}/${symlink} ;fi
    ln -s ${folder} ${tools}/${symlink}
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/271-dhall.sh
#!/bin/bash

export DHALL_VERSION=${version}
export DHALL_ARCH=\${DHALL_ARCH:-x86_64-linux}
export DHALL_HOME=\${TOOLS_HOME:=\$HOME/tools}/dhall-v\${DHALL_VERSION}-\${DHALL_ARCH}/bin

export PATH=\${DHALL_HOME}:\${PATH}
EOD
}

function install_dhall_yaml_binaries {
  local version=${1:-"$DHALL_VERSION"}
  local version=${version:-"1.31.1"}

  local arch=${2:-"$DHALL_ARCH"}
  local arch=${arch:-"x86_64-linux"}

  local vtool=${3:-"$DHALL_YAML_VERSION"}
  local vtool=${vtool:-"1.0.3"}

  local file=dhall-yaml-${vtool}-${arch}.tar.bz2
  local url=https://github.com/dhall-lang/dhall-haskell/releases/download/${version}/${file}
  local folder=dhall-v${version}-${arch}
  local symlink=dhall
  
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

  ##XXX if [ ! -d ${tools}/${folder} ] ;then
    mkdir -p ${tools}/${folder}
    ##XXX tar -C ${tools}/${folder} --strip-components 1 -xpf ${archive}
    tar -C ${tools}/${folder} -xpf ${archive}
  ##XXX fi
  if [ ! -z ${symlink} ] ;then
    if [ -L ${tools}/${symlink} ] ;then rm ${tools}/${symlink} ;fi
    ln -s ${folder} ${tools}/${symlink}
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/271-dhall.sh
#!/bin/bash

export DHALL_VERSION=${version}
export DHALL_ARCH=\${DHALL_ARCH:-x86_64-linux}
export DHALL_HOME=\${TOOLS_HOME:=\$HOME/tools}/dhall-v\${DHALL_VERSION}-\${DHALL_ARCH}/bin

export PATH=\${DHALL_HOME}:\${PATH}
EOD
}

function install_dhall_bash_binaries {
  local version=${1:-"$DHALL_VERSION"}
  local version=${version:-"1.31.1"}

  local arch=${2:-"$DHALL_ARCH"}
  local arch=${arch:-"x86_64-linux"}

  local vtool=${3:-"$DHALL_BASH_VERSION"}
  local vtool=${vtool:-"1.0.29"}

  local file=dhall-bash-${vtool}-${arch}.tar.bz2
  local url=https://github.com/dhall-lang/dhall-haskell/releases/download/${version}/${file}
  local folder=dhall-v${version}-${arch}
  local symlink=dhall
  
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

  ##XXX if [ ! -d ${tools}/${folder} ] ;then
    mkdir -p ${tools}/${folder}
    ##XXX tar -C ${tools}/${folder} --strip-components 1 -xpf ${archive}
    tar -C ${tools}/${folder} -xpf ${archive}
  ##XXX fi
  if [ ! -z ${symlink} ] ;then
    if [ -L ${tools}/${symlink} ] ;then rm ${tools}/${symlink} ;fi
    ln -s ${folder} ${tools}/${symlink}
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/271-dhall.sh
#!/bin/bash

export DHALL_VERSION=${version}
export DHALL_ARCH=\${DHALL_ARCH:-x86_64-linux}
export DHALL_HOME=\${TOOLS_HOME:=\$HOME/tools}/dhall-v\${DHALL_VERSION}-\${DHALL_ARCH}/bin

export PATH=\${DHALL_HOME}:\${PATH}
EOD
}

function install_dhall_nix_binaries {
  local version=${1:-"$DHALL_VERSION"}
  local version=${version:-"1.31.1"}

  local arch=${2:-"$DHALL_ARCH"}
  local arch=${arch:-"x86_64-linux"}

  local vtool=${3:-"$DHALL_NIX_VERSION"}
  local vtool=${vtool:-"1.1.13"}

  local file=dhall-nix-${vtool}-${arch}.tar.bz2
  local url=https://github.com/dhall-lang/dhall-haskell/releases/download/${version}/${file}
  local folder=dhall-v${version}-${arch}
  local symlink=dhall
  
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

  ##XXX if [ ! -d ${tools}/${folder} ] ;then
    mkdir -p ${tools}/${folder}
    ##XXX tar -C ${tools}/${folder} --strip-components 1 -xpf ${archive}
    tar -C ${tools}/${folder} -xpf ${archive}
  ##XXX fi
  if [ ! -z ${symlink} ] ;then
    if [ -L ${tools}/${symlink} ] ;then rm ${tools}/${symlink} ;fi
    ln -s ${folder} ${tools}/${symlink}
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/271-dhall.sh
#!/bin/bash

export DHALL_VERSION=${version}
export DHALL_ARCH=\${DHALL_ARCH:-x86_64-linux}
export DHALL_HOME=\${TOOLS_HOME:=\$HOME/tools}/dhall-v\${DHALL_VERSION}-\${DHALL_ARCH}/bin

export PATH=\${DHALL_HOME}:\${PATH}
EOD
}


function install_dhall {
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
