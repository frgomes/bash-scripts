#!/bin/bash


function install_spark_binaries {
  local spark_version=${1:-"$SPARK_VERSION"}
  local spark_version=${spark_version:-"2.4.3"}

  local hadoop_version=${1:-"$HADOOP_VERSION"}
  local hadoop_version=${hadoop_version:-"2.7"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads > /dev/null
  [[ ! -f spark-${spark_version}-bin-hadoop${hadoop_version}.tgz ]] && \
    wget https://www-eu.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz
  popd > /dev/null

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/spark-${spark_version}-bin-hadoop${hadoop_version} ] ;then
    pushd ${tools} > /dev/null
    tar -xf ~/Downloads/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz
    popd > /dev/null
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/370-spark.sh
#!/bin/bash

export SPARK_VERSION=${spark_version}
export HADOOP_VERSION=${hadoop_version}
export SPARK_HOME=\${TOOLS_HOME:=\$HOME/tools}/spark-\${SPARK_VERSION}-bin-hadoop\${HADOOP_VERSION}

export PATH=\${SPARK_HOME}/bin:\${PATH}
EOD
}

function install_spark {
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
