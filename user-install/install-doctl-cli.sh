#!/bin/bash

function install_doctl_cli {
  if [ ! -x ~/bin/doctl ] ;then
    pushd ~/bin > /dev/null 2>&1
    curl -sL http://github.com/digitalocean/doctl/releases/download/v1.8.3/doctl-1.8.3-linux-amd64.tar.gz | tar xpzf -
    popd > /dev/null 2>&!
  fi
  readlink -f ~/bin/doctl
}

install_doctl_cli
