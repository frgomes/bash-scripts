#!/bin/bash -x


function install_java_binaries {
  local version=${1:-"$JAVA_VERSION"}
  local version=${version:="11.0.5"}

  if [[ $version =~ ^(1\.)?7\.* ]] ;then
    local file=openjdk-7u75-b13-linux-x64-18_dec_2014.tar.gz
    local url=https://download.java.net/openjdk/jdk7u75/ri/${file}
    local folder=java-se-7u75-ri
    local symlink=jdk7
  elif [[ $version =~ ^(1\.)?8\.* ]] ;then
    local file=openjdk-8u40-b25-linux-x64-10_feb_2015.tar.gz
    local url=https://download.java.net/openjdk/jdk8u40/ri/${file}
    local folder=java-se-8u40-ri
    local symlink=jdk8
  elif [[ $version =~ ^11\.* ]] ;then
    local file=openjdk-11+28_linux-x64_bin.tar.gz
    local url=https://download.java.net/openjdk/jdk11/ri/${file}
    local folder=jdk-11
    local symlink=jdk11
  elif [[ $version =~ ^12\.* ]] ;then
    local file=openjdk-12+32_linux-x64_bin.tar.gz
    local url=https://download.java.net/openjdk/jdk12/ri/${file}
    local folder=jdk-12
    local symlink=jdk12
  elif [[ $version =~ ^13\.* ]] ;then
    local file=openjdk-13+33_linux-x64_bin.tar.gz
    local url=https://download.java.net/openjdk/jdk13/ri/${file}
    local folder=jdk-13
    local symlink=jdk13
  else
    echo "ERROR: Unsupported Java version $JAVA_VERSION"
    echo 'INFO: Supported JDK versions are: 1.7.*, 1.8.*, 11.*, 12.* and 13.*'
    return 1
  fi

  local tools=${TOOLS_HOME:=${HOME}/tools}
  local Software=${SOFTWARE_HOME:=/mnt/omv/Software}

  [[ ! -d ${HOME}/Downloads ]] && mkdir -p ${HOME}/Downloads
  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
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
    tar -C ${tools} -xpf ${archive}
  fi
  if [ ! -z ${symlink} ] ;then
    if [ -L ${tools}/${symlink} ] ;then rm ${tools}/${symlink} ;fi
    ln -s ${folder} ${tools}/${symlink}
  fi
}

function install_java {
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
