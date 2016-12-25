#!/bin/bash

function proxy_status {
  env | fgrep -i _proxy
}

function proxy_on {
  if [ $(netstat -an | fgrep 3128 | wc -l) -gt 0 ] ;then
    ip=$(netstat -an | fgrep ":3128 " | head -1 | sed -r 's/[ \t]+/ /g' | cut -d' ' -f5 | cut -d: -f1)
    export JAVA_OPTS="${JAVA_OPTS} -Dhttp.proxyHost=${ip} -Dhttp.proxyPort=3128"
    export HTTP_PROXY=http://${ip}:3128
    export http_proxy=http://${ip}:3128
    export  FTP_PROXY=http://${ip}:3128
    export  ftp_proxy=http://${ip}:3128
  fi
}

function proxy_off {
  unset HTTP_PROXY http_proxy FTP_PROXY ftp_proxy
}

proxy_on
