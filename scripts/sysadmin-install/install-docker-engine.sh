#!/bin/bash -x

# compiled from https://docs.docker.com/engine/installation/linux/debian/

function install_docker_working_folder {
  if [ -d /data ] ;then 
    local storage=/data/srv/lib/docker
  else
    local storage=/srv/lib/docker
  fi
  [[ ! -d ${storage} ]] && sudo mkdir -p ${storage}
  [[ ! -d /var/lib/docker ]] && sudo ln -s ${storage} /var/lib/docker
} 

function install_docker {
  sudo apt install lsb-release apt-transport-https dirmngr -y

  local release=$(lsb_release -cs)

  echo deb https://apt.dockerproject.org/repo debian-${release} main | sudo tee /etc/apt/sources.list.d/docker.list
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

  sudo apt update
  sudo apt-cache policy docker-engine
  sudo apt install docker-engine docker-compose -y

  sudo groupadd docker
  sudo gpasswd -a $USER docker
  sudo service docker restart
}


install_docker_working_folder && install_docker
