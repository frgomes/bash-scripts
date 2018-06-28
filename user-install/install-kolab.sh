#!/bin/bash

username=${LOGNAME}

cat > /etc/apt/sources.list.d/kolab.list <<FINISH
deb http://obs.kolabsys.com/repositories/Kolab:/3.4/Debian_8.0/ ./
deb http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/Debian_8.0/ ./
deb http://obs.kolabsys.com/repositories/home:/$username:/branches:/Kolab:/Development/Debian_8.0/ ./
FINISH

wget http://obs.kolabsys.com/repositories/Kolab:/3.4/Debian_8.0/Release.key
apt-key add Release.key; rm -rf Release.key
wget http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/Debian_8.0/Release.key
apt-key add Release.key; rm -rf Release.key
wget http://obs.kolabsys.com/repositories/home:/$username:/branches:/Kolab:/Development/Debian_8.0/Release.key
apt-key add Release.key; rm -rf Release.key

cat > /etc/apt/preferences.d/kolab <<FINISH
Package: *
Pin: origin obs.kolabsys.com
Pin-Priority: 501
FINISH

apt update
# workaround: first install apache2 from Jessie, we don't want apache2 from the Kolab repos which was needed for Wheezy
apt install apache2 -t stable
aptitude install kolab
