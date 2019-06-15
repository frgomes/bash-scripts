#!/bin/bash


function install_nifi {
  local version=${1:-"$NIFI_VERSION"}
  local version=${version:-"1.7.1"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  [[ ! -f ~/Downloads/nifi-${version}-bin.tar.gz ]] && \
    wget http://www.mirrorservice.org/sites/ftp.apache.org/nifi/${version}/nifi-${version}-bin.tar.gz -O ~/Downloads/nifi-${version}-bin.tar.gz
  
  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p $tools
  [[ ! -d ${tools}/nifi-${version} ]] 
  tar -C ${tools} -xf ~/Downloads/nifi-${version}-bin.tar.gz

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/361-nifi.sh
#!/bin/bash

export NIFI_VERSION=${version}
export NIFI_HOME=\${TOOLS_HOME:=\$HOME/tools}/nifi-\${NIFI_VERSION}

export PATH=\${NIFI_HOME}/bin:\${PATH}
EOD
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  fgrep "function " $self | cut -d' ' -f2 | head -n -2
else
  # echo "Script is a subshell"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  cmd=$(fgrep "function " $self | cut -d' ' -f2 | head -n -2 | tail -1)
  # echo $cmd
  $cmd $*
fi
