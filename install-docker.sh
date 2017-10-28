#!/bin/bash

# compiled from https://docs.docker.com/engine/installation/linux/debian/

function install_docker_working_folder {
  [[ ! -d /srv/lib/docker ]] && sudo mkdir -p /srv/lib/docker
  [[ ! -d /var/lib/docker ]] && sudo ln -s /srv/lib/docker /var/lib/docker
} 

function install_docker {
  sudo apt-get install lsb-release apt-transport-https dirmngr -y

  release=$(lsb_release -cs)
  echo deb https://apt.dockerproject.org/repo debian-${release} main | sudo tee /etc/apt/sources.list.d/docker.list
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

  sudo apt-get update
  sudo apt-cache policy docker-engine
  sudo apt-get install docker-engine docker-compose -y

  sudo groupadd docker
  sudo gpasswd -a $USER docker
  sudo service docker restart
}


install_docker_working_folder && install_docker
