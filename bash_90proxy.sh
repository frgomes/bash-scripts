#!/bin/bash

###
# NOTE: Proxy definitions are NOT LOADED BY DEFAULT.
#       This is intentional, since some applications do not behave well
#       behind a proxy server.
#       More info:
#           /var/lib/proxydriver/environment.sh
#           /etc/proxydriver.d/environment.sh
#           /etc/proxy.pac
#           /etc/apt/apt.conf.d/80proxy
###

#alias proxy_reset='`env | fgrep -i _proxy | cut -d= -f1 | xargs echo unset`'
#alias proxy_define='source /etc/proxydriver.d/environment.sh'
#alias proxy_show='env | fgrep -i _proxy'

if [ $(netstat -an | fgrep 3128 | wc -l) -gt 0 ] ;then
  export JAVA_OPTS="${JAVA_OPTS} -Dhttp.proxyHost=localhost -Dhttp.proxyPort=3128"
fi
