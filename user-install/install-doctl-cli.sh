#!/bin/bash

function install_doctl_cli {
  if [ ! -x ~/bin/doctl ] ;then
    pushd ~/bin > /dev/null 2>&1
    curl -sL http://github.com/digitalocean/doctl/releases/download/v1.8.3/doctl-1.8.3-linux-amd64.tar.gz | tar xpzf -
    popd > /dev/null 2>&!
  fi
  readlink -f ~/bin/doctl
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
