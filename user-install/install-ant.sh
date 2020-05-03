#!/bin/bash


function install_ant_binaries {
  local version=${1:-"$ANT_VERSION"}
  local version=${version:-"1.9.14"}

  [[ ! -d "${DOWNLOADS}" ]] && mkdir -p "${DOWNLOADS}"
  pushd "${DOWNLOADS}"
  [[ ! -f apache-ant-${version}-bin.tar.gz ]] \
    && wget https://www-eu.apache.org/dist/ant/binaries/apache-ant-${version}-bin.tar.gz
  popd
  
  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools
  pushd $tools \
    && tar -xf "${DOWNLOADS}"/apache-ant-${version}-bin.tar.gz

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/331-ant.sh
#!/bin/bash

export ANT_VERSION=${version}
export ANT_HOME=\${TOOLS_HOME:=\$HOME/tools}/apache-ant-\${ANT_VERSION}

export PATH=\${ANT_HOME}/bin:\${PATH}
EOD
}


function install_ant {
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
