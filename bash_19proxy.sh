#!/bin/bash

function proxy_status {
  env | fgrep -i _proxy
}

function proxy_finder {
  if [ $(netstat -an | fgrep 3128 | wc -l) -gt 0 ] ;then
    ip=$(netstat -an | fgrep ":3128 " | head -1 | sed -r 's/[ \t]+/ /g' | cut -d' ' -f5 | cut -d: -f1)
    if [[ -z "$ip" ]] ;then
      echo "http://localhost:3128"
    else
      echo "http://${ip}:3128"
    fi
  fi
}

function proxy_on {
  if [ -z "$1" ] ;then
    local proxy=$(proxy_finder)
  else
    local proxy=$1
  fi
  if [[ ! -z "${proxy}" ]] ;then
    export HTTP_PROXY=${proxy}
    export http_proxy=${proxy}
    export  FTP_PROXY=${proxy}
    export  ftp_proxy=${proxy}

    local host=$(echo $proxy | cut -d/ -f3 | cut -d: -f1)
    local port=$(echo $proxy | cut -d/ -f3 | cut -d: -f2)
    export JAVA_OPTS="${JAVA_OPTS} -Dhttp.proxyHost=${host} -Dhttp.proxyPort=${port}"
  fi
}

function proxy_off {
  unset HTTP_PROXY http_proxy FTP_PROXY ftp_proxy
}

proxy_on
