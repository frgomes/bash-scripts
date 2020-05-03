#!/bin/bash

function swagger_editor {
  docker pull swaggerapi/swagger-editor
  docker run -d -p ${PORT_SWAGGER:=8811}:8080 swaggerapi/swagger-editor
  chromium http://localhost:${PORT_SWAGGER:=8811}/ &
}


function swagger_cli_download {
  local v=3.1.0
  local name=swagger-codegen-cli-3.0.0-20180630.155857-85.jar
  local url=http://central.maven.org/maven2/org/openapitools/openapi-generator-cli/${v}/openapi-generator-cli-${v}.jar
  local file=~/Downloads/$name
  if [ ! -f $file ] ;then
    mkdir -p ~/Downloads > /dev/null
    pushd ~/Downloads > /dev/null
    wget -qq $url
    popd > /dev/null
  fi
  echo $file
}

function swagger_codegen {
  local jar=$(swagger_cli_download)
  java -jar $jar $*
}

function swagger_finch {
  local jar=$(swagger_cli_download)
  if [ $# != 2 ] ;then
    echo 'swagger_finch <input URL> <output DIR>'
    java -jar $jar -h generate
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
