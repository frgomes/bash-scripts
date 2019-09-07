#!/bin/bash -x


function install_java {
  local version=${1:-"$JAVA_VERSION"}
  local version=${version:="11.0.2"}

  if [[ $version =~ 1\.8\.0_40 ]] ;then
    local url=https://download.java.net/openjdk/jdk8u40/ri/openjdk-8u40-b25-linux-x64-10_feb_2015.tar.gz
    local file=openjdk-8u40-b25-linux-x64-10_feb_2015.tar.gz
    local options=
    local folder=java-se-8u40-ri
    local symlink=jdk8
  elif [[ $version =~ 11\.0\.1 ]] ;then
    local url=https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz
    local file=openjdk-11.0.1_linux-x64_bin.tar.gz
    local folder=jdk-11.0.1
    local symlink=jdk11
    local options=
  elif [[ $version =~ 11\.0\.2 ]] ;then
    local url=https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz
    local file=openjdk-11.0.2_linux-x64_bin.tar.gz
    local folder=jdk-11.0.2
    local symlink=jdk11
    local options=
  elif [[ $version =~ 12\.0\.1 ]] ;then
    local url=https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_linux-x64_bin.tar.gz
    local file=openjdk-12.0.1_linux-x64_bin.tar.gz
    local folder=jdk-12.0.1
    local symlink=jdk12
    local options=
  else
    echo ERROR: Unsupported Java version $JAVA_VERSION
    echo INFO: Supported JDK versions are: 1.8.0_40, 11.0.1, 11.0.2 and 12.0.1
    return 1
  fi

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${HOME}/Downloads ]] && mkdir -p ${HOME}/Downloads
  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [[ ! -f ${HOME}/Downloads/${file} ]] ;then
    echo wget "$url" "${options}" -O "${file}"
  fi

  if [ ! -d ${tools}/${folder} ] ;then
    pushd ${tools} > /dev/null
    tar -xpf ${HOME}/Downloads/${file}
    popd > /dev/null
  fi
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
