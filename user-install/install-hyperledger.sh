#!/bin/bash

function install_hyperledger_fabric {
    mkdir -p $HOME/go/{bin,src}
    pushd $HOME/go/src
    mkdir -p github.com/hyperledger
    cd github.com/hyperledger
    if [ ! -d fabric ] ;then
        git clone http://github.com/hyperledger/fabric
    else
        pushd fabric
        git pull --rebase
        popd
    fi
    if [ ! -d fabric-samples ] ;then
        git clone http://github.com/hyperledger/fabric-samples
    else
        pushd fabric-samples
        git pull --rebase
        popd
    fi
    cd fabric
    if [ ! -d fabric-prototype ] ;then
        git clone https://github.com/jeffgarratt/fabric-prototype.git
    else
        pushd fabric-prototype
        git pull --rebase
        popd
    fi
    popd
}

function install_hyperledger_iroha {
    local tag=${1:-1.0.0_rc3}
    local network=$(docker network ls -f "name=iroha-network" -q)
    [[ -z "${network}" ]] && docker network create iroha-network
    docker run \
           --name some-postgres \
           -e POSTGRES_USER=postgres \
           -e POSTGRES_PASSWORD=mysecretpassword \
           -p 5432:5432 \
           --network=iroha-network \
           -d postgres:9.5

    local volume=$(docker volume ls -f "name=blockstore" -q)
    [[ -z "${volume}" ]] && docker volume create blockstore

    mkdir -p ~/workspace
    pushd ~/workspace
    if [ ! -d iroha ] ;then
        git clone https://github.com/hyperledger/iroha
        cd iroha
    else
        cd iroha
        git pull
    fi
    git checkout ${tag}
    
    docker run -it \
           --name iroha \
           -p 50051:50051 \
           -v ~/workspace/iroha/example:/opt/iroha_data \
           -v blockstore:/tmp/block_store \
           --network=iroha-network \
           --entrypoint=/bin/bash \
           hyperledger/iroha:${tag}
    popd
    echo "NOTES:"
    echo "    1. dnsmasq must be running. See: https://docs.docker.com/v17.09/engine/userguide/networking/configure-dns/"
    echo "    2. Remember to disable the firewall when in development mode."
}

function install_hyperledger {
    echo INFO: Please source this script and run one of its functions for a specific implementation.
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
