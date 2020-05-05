#!/bin/bash


function install_nifi_binaries {
  local version=${1:-"$NIFI_VERSION"}
  local version=${version:-"1.7.1"}

  [[ ! -d "${DOWNLOADS}" ]] && mkdir -p "${DOWNLOADS}"
  [[ ! -f "${DOWNLOADS}"/nifi-${version}-bin.tar.gz ]] && \
    wget http://www.mirrorservice.org/sites/ftp.apache.org/nifi/${version}/nifi-${version}-bin.tar.gz -O "${DOWNLOADS}"/nifi-${version}-bin.tar.gz
  
  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p $tools
  [[ ! -d ${tools}/nifi-${version} ]] 
  tar -C ${tools} -xf "${DOWNLOADS}"/nifi-${version}-bin.tar.gz

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/361-nifi.sh
#!/bin/bash

export NIFI_VERSION=${version}
export NIFI_HOME=\${TOOLS_HOME:=\$HOME/tools}/nifi-\${NIFI_VERSION}

export PATH=\${NIFI_HOME}/bin:\${PATH}
EOD
}

function install_nifi {
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
