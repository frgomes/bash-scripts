#!/bin/bash

function swagger_editor {
  docker pull swaggerapi/swagger-editor
  docker run -d -p ${PORT_SWAGGER}:8080 swaggerapi/swagger-editor
  chromium http://localhost:${PORT_SWAGGER}/ &
}


function swagger_cli_download {
  local ver=2.3.0-SNAPSHOT
  local name=swagger-codegen-cli-2.3.0-20170731.145436-42.jar
  local url=https://oss.sonatype.org/content/repositories/snapshots/io/swagger/swagger-codegen-cli/$ver/$name
  local file=~/Downloads/$name
  if [ ! -f $file ] ;then
    mkdir -p ~/Downloads > /dev/null
    pushd ~/Downloads > /dev/null
    wget -qq $url
    popd > /dev/null
  fi
  echo $file
}


function swagger_finch {
  local jar=$(swagger_cli_download)
  if [ $# != 2 ] ;then
    echo 'swagger_finch <input URL> <output DIR>'
  else
    java -jar $jar generate -l finch -i $1 -o $2
  fi
}


function swagger_angular {
  local jar=$(swagger_cli_download)
  if [ $# != 2 ] ;then
    echo 'swagger_finch <input URL> <output DIR>'
  else
    java -jar $jar generate -l typescript-angular -i $1 -o $2
  fi
}
