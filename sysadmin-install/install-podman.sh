#!/bin/bash

if [ ! -f /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list ] ;then
  echo 'deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/ /' | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list > /dev/null
  curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10/Release.key | sudo apt-key add -
fi

sudo apt-get update -qq
sudo apt-get -qq -y install podman

echo 'kernel.unprivileged_userns_clone=1' | sudo tee /etc/sysctl.d/00-local-userns.conf > /dev/null
sudo service procps restart
