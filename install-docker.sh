#!/bin/bash

# compiled from https://docs.docker.com/engine/installation/linux/debian/#/debian-jessie-80-64-bit

sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install apt-transport-https ca-certificates -y

sudo sh -c "echo deb https://apt.dockerproject.org/repo debian-jessie main > /etc/apt/sources.list.d/docker.list"
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

sudo apt-get update
sudo apt-cache policy docker-engine
sudo apt-get install docker-engine -y

sudo service docker start
sudo docker run hello-world

sudo group add docker
sudo groupadd docker
sudo gpasswd -a $USER docker
sudo service docker restart
