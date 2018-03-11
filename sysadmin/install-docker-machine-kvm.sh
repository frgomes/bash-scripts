#!/bin/bash -x


function install_docker_machine {
  local version=${1:-"0.14.0"}
  local name=docker-machine-$(uname -s)-$(uname -m)

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f ${name} ]] \
    && wget https://github.com/docker/machine/releases/download/v${version}/${name}
  popd
  
  sudo install ~/Downloads/${name} /usr/local/bin/docker-machine

  echo /usr/local/bin/docker-machine
}

function install_docker_machine_kvm {
  local version=${1:-"0.10.0"}
  local osarch=centos7

  local name=docker-machine-driver-kvm-${osarch}

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f ${name} ]] \
    && wget https://github.com/dhiltgen/docker-machine-kvm/releases/download/v${version}/${name}
  popd
  
  sudo install ~/Downloads/${name} /usr/local/bin/docker-machine-driver-kvm

  echo /usr/local/bin/docker-machine-driver-kvm
}

install_docker_machine && install_docker_machine_kvm
