#!/bin/bash

# compiled from https://docs.docker.com/engine/installation/linux/debian/

function install_docker_working_folder {
    if [ -d /data ] ;then 
        local storage=/data/srv/lib/docker
    else
        local storage=/srv/lib/docker
    fi
    [[ ! -d ${storage} ]] && sudo mkdir -p ${storage}
    [[ ! -d /var/lib/docker ]] && sudo ln -s ${storage} /var/lib/docker
    return 0
} 

function install_docker_binaries {
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates wget software-properties-common

    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

    wget https://download.docker.com/linux/debian/gpg -O - | sudo apt-key add -

    echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
    sudo apt install -y dnsmasq docker.io docker-compose
}

function install_docker_permissions {
    sudo usermod -a -G docker ${USER}
}

function install_docker {
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
