#!/bin/bash

sudo apt-get install -y squid3

# make a configuration which just works
sudo cp -p /etc/squid/squid.conf /etc/squid/squid.conf.ORIGINAL
sudo tee /etc/squid/squid.conf > /dev/null < EOD
acl localnet src 192.168.0.0/16,172.16.0.0/12,10.0.0.0/8,fc00::/7,fe80::/10                                    
acl SSL_ports port 443
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
acl CONNECT method CONNECT

http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost manager
http_access deny manager
http_access allow localhost
http_access deny all
http_port 3128

cache_dir ufs /var/spool/squid 100 16 256

coredump_dir /var/spool/squid

refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320

# Disable Cache for defined domains
acl disable-cache dstdomain "/etc/squid/squid.ignore.acl"
cache deny disable-cache
EOD

# make sure we create all directories needed by the configuration
sudo mkdir -p /var/log/squid/ /var/run/squid /var/spool/squid

# echo restart squid
echo "Restarting squid (this may take some time) ..."
sudo service squid restart
