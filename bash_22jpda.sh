#!/bin/bash

function jpda_on {
  local port=$1
  local port=${port:=5005}
  export JAVA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=${port}"
  echo $JAVA_OPTS
}

function jpda_off {
  export JAVA_OPTS=""
  echo $JAVA_OPTS
}

function jpda_status {
  local port=$1
  local port=${port:=5005}
  ps -ef | fgrep java | fgrep jdwp | fgrep "transport=dt_socket,address="
}
