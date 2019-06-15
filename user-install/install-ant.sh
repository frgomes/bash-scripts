#!/bin/bash


function install_ant {
  local version=${1:-"$ANT_VERSION"}
  local version=${version:-"1.9.14"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f apache-ant-${version}-bin.tar.gz ]] \
    && wget https://www-eu.apache.org/dist/ant/binaries/apache-ant-${version}-bin.tar.gz
  popd
  
  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools
  pushd $tools \
    && tar -xf ~/Downloads/apache-ant-${version}-bin.tar.gz

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/331-ant.sh
#!/bin/bash

export ANT_VERSION=${version}
export ANT_HOME=\${TOOLS_HOME:=\$HOME/tools}/apache-ant-\${ANT_VERSION}

export PATH=\${ANT_HOME}/bin:\${PATH}
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
