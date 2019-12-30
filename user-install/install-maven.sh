#!/bin/bash


function install_maven_binaries {
  local version=${1:-"$M2_VERSION"}
  local version=${version:-"3.6.1"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f apache-maven-${version}-bin.tar.gz ]] \
    && wget http://www.mirrorservice.org/sites/ftp.apache.org/maven/maven-3/${version}/binaries/apache-maven-${version}-bin.tar.gz
  popd
  
  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d $tools ]] && mkdir -p $tools
  pushd $tools \
    && tar -xf ~/Downloads/apache-maven-${version}-bin.tar.gz

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/330-maven.sh
#!/bin/bash

export M2_VERSION=${M2_VERSION}
export M2_HOME=\${TOOLS_HOME:=\$HOME/tools}/apache-maven-\${M2_VERSION}
export MAVEN_OPTS="-Xmx2048m"

export PATH=\${M2_HOME}/bin:\${PATH}
EOD
}

function install_maven {
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
