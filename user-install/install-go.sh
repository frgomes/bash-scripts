#!/bin/bash -eu


function install_go_binaries {
  local version=${1:-"$GO_VERSION"}
  local version=${version:-"1.11.5"}

  local arch=${2:-"$GO_ARCH"}
  local arch=${arch:-"linux-amd64"}

  [[ ! -d "${DOWNLOADS}" ]] && mkdir -p "${DOWNLOADS}"
  pushd "${DOWNLOADS}"
  local archive=go${version}.${arch}.tar.gz
  [[ ! -f ${archive} ]] \
    && wget https://dl.google.com/go/${archive}
  popd

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools
  pushd $tools \
    && tar -xf "${DOWNLOADS}"/${archive}


  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/500-go.sh
#!/bin/bash

export GO_VERSION=${version}
export GO_ARCH=${arch}
export GO_HOME=\${TOOLS_HOME:=\$HOME/tools}/go\${GO_VERSION}.\${GO_ARCH}
export GO_PATH=\${GO_HOME}

export PATH=\${GO_HOME}/bin:\${PATH}
EOD
}

function install_go {
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
