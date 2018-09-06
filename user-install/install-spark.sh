#!/bin/bash


function install_spark {
  echo default Spark  is $SPARK_VERSION
  echo default Hadoop is $HADOOP_VERSION

  local spark_version=${1:-"$SPARK_VERSION"}
  local spark_version=${spark_version:-"2.2.0"}

  local hadoop_version=${1:-"$HADOOP_VERSION"}
  local hadoop_version=${hadoop_version:-"2.7"}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads > /dev/null
  [[ ! -f spark-${spark_version}-bin-hadoop${hadoop_version}.tgz ]] && wget http://www.apache.org/dyn/closer.lua/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz
  popd > /dev/null

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/spark-${spark_version}-bin-hadoop${hadoop_version} ] ;then
    pushd ${tools} > /dev/null
    tar -xf ~/Downloads/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz
    popd > /dev/null
  fi

  echo ${tools}/spark-${spark_version}-bin-hadoop${hadoop_version}
}


install_spark $*
