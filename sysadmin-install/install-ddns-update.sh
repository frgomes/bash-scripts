#!/bin/bash

dir=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))

echo Installing ddns-update ...
cp ${dir}/assets/ddns-update /sbin/ddns-update
chmod 755 /sbin/ddns-update
