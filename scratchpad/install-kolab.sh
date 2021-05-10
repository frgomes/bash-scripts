#!/bin/bash


function install_kolab_binaries {
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

    sudo aptitude update
    # workaround: first install apache2 from Jessie, we don't want apache2 from the Kolab repos which was needed for Wheezy
    sudo aptitude install -y apache2 -t stable
    sudo aptitude install -y kolab
}

function install_kolab {
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
