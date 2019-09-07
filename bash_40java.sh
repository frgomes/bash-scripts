#!/bin/bash

function java_alternatives_install {
  for file in ${JAVA_HOME}/bin/* ;do
    if [ -x $file ] ;then
      local filename=`basename $file`
      sudo update-alternatives --install /usr/bin/$filename $filename $file 20000
      sudo update-alternatives --set $filename $file
    fi
  done
}
