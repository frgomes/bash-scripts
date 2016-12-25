#!/bin/bash

function proxy_status {
  env | fgrep -i _proxy
}

function proxy_on {
  if [ $(netstat -an | fgrep 3128 | wc -l) -gt 0 ] ;then
    export JAVA_OPTS="${JAVA_OPTS} -Dhttp.proxyHost=localhost -Dhttp.proxyPort=3128"
    export HTTP_PROXY=localhost:3128
    export http_proxy=localhost:3128
    export  FTP_PROXY=localhost:3128
    export  ftp_proxy=localhost:3128
  fi
}

function proxy_off {
  unset HTTP_PROXY http_proxy FTP_PROXY ftp_proxy
}
