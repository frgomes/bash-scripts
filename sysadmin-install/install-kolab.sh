#!/bin/bash


function install_kolab {
    username=${LOGNAME}

    cat > /etc/apt/sources.list.d/kolab.list <<EOD
deb http  ://obs.kolabsys.com/repositories/Kolab:/3.4/Debian_8.0/ ./
deb http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/Debian_8.0/ ./
deb http://obs.kolabsys.com/repositories/home:/$username:/branches:/Kolab:/Development/Debian_8.0/ ./
EOD

    wget http://obs.kolabsys.com/repositories/Kolab:/3.4/Debian_8.0/Release.key
    apt-key add Release.key; rm -rf Release.key
    wget http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/Debian_8.0/Release.key
    apt-key add Release.key; rm -rf Release.key
    wget http://obs.kolabsys.com/repositories/home:/$username:/branches:/Kolab:/Development/Debian_8.0/Release.key
    apt-key add Release.key; rm -rf Release.key
    
    cat > /etc/apt/preferences.d/kolab <<EOD
Package: *
Pin: origin obs.kolabsys.com
Pin-Priority: 501
EOD

    sudo apt update
    # workaround: first install apache2 from Jessie, we don't want apache2 from the Kolab repos which was needed for Wheezy
    sudo apt install -y apache2 -t stable
    sudo apt install -y kolab
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  fgrep "function " $self | cut -d' ' -f2 | head -n -2
else
  # echo "Script is a subshell"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  cmd=$(fgrep "function " $self | cut -d' ' -f2 | head -n -2 | tail -1)
  # echo $cmd
  $cmd $*
fi
