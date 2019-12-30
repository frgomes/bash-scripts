#!/bin/bash


function install_kafka_binaries {
  local version=${1:-"$KAFKA_VERSION"}
  local version=${version:-"2.3.0"}

  local scala=${2:-"$SCALA_VERSION_MAJOR"}
  local scala=${scala:-"2.12"}

  local product=kafka_${scala}-${version}
  local archive=${product}.tgz

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads > /dev/null
  [[ ! -f ${archive} ]] && wget http://www.mirrorservice.org/sites/ftp.apache.org/kafka/${version}/${archive}

  popd > /dev/null

  local tools=${TOOLS_HOME:=$HOME/tools}
  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/${product} ] ;then
    pushd ${tools} > /dev/null
    [[ -e sbt ]] && rm -r -f sbt
    tar -xf ~/Downloads/${archive}
    popd > /dev/null
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/360-kafka.sh
#!/bin/bash

export KAFKA_VERSION=${version}
export KAFKA_HOME=\${TOOLS_HOME:=\$HOME/tools}/kafka_\${SCALA_VERSION_MAJOR:-2.12}-\${KAFKA_VERSION}

export PATH=\${KAFKA_HOME}/bin:\${PATH}
EOD
}

function install_kafka {
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
