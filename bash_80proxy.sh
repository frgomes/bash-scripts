#!/bin/bash

## see: http://askubuntu.com/questions/650941/how-to-set-global-proxy-in-ubuntu-from-configuration-url

function proxy_plugin_environment {
  local proxy=$1
  if [ -z "${proxy}" ] ;then
    [[ -f /etc/environment ]] && sudo rm /etc/environment
  else
    sudo tee - /etc/environment << EOD
http_proxy=${proxy}
https_proxy=${proxy}
ftp_proxy=${proxy}
EOD
  fi
}

function proxy_plugin_apt {
  local proxy=$1
  if [ -z "${proxy}" ] ;then
    [[ -f /etc/apt/apt.conf.d/80proxy ]] && sudo rm /etc/apt/apt.conf.d/80proxy
  else
    sudo tee - /etc/apt/apt.conf.d/80proxy << EOD
Acquire::http::Proxy  "${proxy}";
Acquire::https::Proxy "${proxy}";
Acquire::ftp::Proxy   "${proxy}";
EOD
  fi
  [[ -f /etc/apt/apt.conf ]] && echo "You should consider reviewing and ultimately removing /etc/apt/apt.conf"
}

function proxy_plugin_npm {
  local proxy=$1
  if [ -z "${proxy}" ] ;then
    unset npm_config_proxy
    unset npm_config_https_proxy
  else
    export npm_config_proxy=${proxy}
    export npm_config_https_proxy=${proxy}
  fi
}

function proxy_plugin_java {
  local proxy=$1
  if [ -z "${proxy}" ] ;then
    unset JAVA_OPTS_PROXY
  else
    local host=$(echo $proxy | cut -d/ -f3 | cut -d: -f1)
    local port=$(echo $proxy | cut -d/ -f3 | cut -d: -f2)
    export JAVA_OPTS_PROXY="-Dhttp.proxyHost=${host} -Dhttp.proxyPort=${port}"
  fi
}


#-------------------------------------------------------------------------------------------------------

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

#-------------------------------------------------------------------------------------------------------


function proxy_status {
  [[ -f /etc/environment ]] && cat /etc/environment
}

function proxy_on {
  if [ -z "$1" ] ;then
    local proxy=$(proxy_finder)
  else
    local proxy=$1
  fi
  proxy_plugin_environment ${proxy}
  proxy_plugin_apt ${proxy}
  proxy_plugin_npm ${proxy}
  proxy_plugin_java ${proxy}
}

function proxy_off {
  proxy_plugin_environment
  proxy_plugin_apt
  proxy_plugin_npm
  proxy_plugin_java
}

proxy_off
