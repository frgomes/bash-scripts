#!/bin/bash

mkdir ~/workspace
pushd ~/workspace

if [ -d zeppelin ] ;then
  cd zeppelin
  git pull
else
  git clone https://github.com/apache/zeppelin
  cd zeppelin
fi

mvn clean package -Pscala-2.11 -Pspark-1.6 -Phadoop-2.7 -Psparkr -Ppyspark -Pyarn -DskipTests

popd
