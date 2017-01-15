#!/bin/bash

function proxy_status {
  env | fgrep -i _proxy | sort
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
    # bash
    export HTTP_PROXY=${proxy}
    export http_proxy=${proxy}
    export  FTP_PROXY=${proxy}
    export  ftp_proxy=${proxy}
    # npm
    export npm_config_proxy=${proxy}
    export npm_config_https_proxy=${proxy}
    # java
    local host=$(echo $proxy | cut -d/ -f3 | cut -d: -f1)
    local port=$(echo $proxy | cut -d/ -f3 | cut -d: -f2)
    export JAVA_OPTS_PROXY="-Dhttp.proxyHost=${host} -Dhttp.proxyPort=${port}"
  fi
}

function proxy_off {
  unset HTTP_PROXY http_proxy FTP_PROXY ftp_proxy npm_config_proxy npm_config_https_proxy JAVA_OPTS_PROXY
}

proxy_on
