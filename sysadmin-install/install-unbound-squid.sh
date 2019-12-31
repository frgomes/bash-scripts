#!/bin/bash

# Note: Squid does not handle DNS requests. For DNS caching we use Unbound.
#       DNS caching does not happen by magic: you need to explicitly configure
#       your DNS server to 127.0.0.1

function install_unbound_squid_binaries {
    sudo apt install unbound squid3 -y

    # make a configuration which just works
    sudo cp -p /etc/squid/squid.conf /etc/squid/squid.conf.ORIGINAL
    sudo tee /etc/squid/squid.conf > /dev/null <<EOD
acl localnet src 192.168.0.0/16,172.16.0.0/12,10.0.0.0/8,fc00::/7,fe80::/10

acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http
acl Safe_ports port 993         # IMAP/TLS
acl Safe_ports port 995         # POP3/TLS

acl CONNECT_ports port 443
acl CONNECT_ports port 993
acl CONNECT_ports port 995

acl CONNECT method CONNECT

http_access deny !Safe_ports
http_access deny CONNECT !CONNECT_ports
http_access allow localhost manager
http_access deny manager
http_access allow localhost
http_access deny all

http_port 3128

cache_dir ufs /var/spool/squid 100 16 256

coredump_dir /var/spool/squid

refresh_pattern ^ftp:             1440    20%     10080
refresh_pattern ^gopher:          1440     0%      1440
refresh_pattern -i (/cgi-bin/|\?)    0     0%         0
refresh_pattern .                    0    20%      4320

# Disable Cache for defined domains
acl disable-cache dstdom_regex -i "/etc/squid/squid.ignore.acl"
cache deny disable-cache
EOD

    if [[ ! -f /etc/squid/squid.ignore.acl ]] ;then
        sudo tee /etc/squid/squid.ignore.acl > /dev/null <<EOD
(^|\.)whatsapp.com
(^|\.)hangouts.google.com
(^|\.)wire.com
(^|\.)gitter.im
EOD
    fi

    # make sure we create all directories needed by the configuration
    sudo mkdir -p /var/log/squid/ /var/spool/squid

    # echo restart squid
    echo "Restarting squid (this may take some time) ..."
    sudo service squid restart
}

function install_unbound_squid {
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd $*
  done
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(grep -E "^function " $self | cut -d' ' -f2 | tail -1)
  $cmd $*
fi
