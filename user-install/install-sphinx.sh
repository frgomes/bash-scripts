#!/bin/bash

# Sphinx is employed by Linux kernel and so do we: https://www.youtube.com/watch?v=jY_C-Z0qMSo
# see: https://downloads.lightbend.com/paradox/akka-docs-new/20170510-wip/scala/dev/documentation.html

function install_sphinx {
    pip install --user python-sphinx

    mkdir -p ~/tmp
    if [ ! -d ~/tmp/sphinx-contrib ] ;then
        pushd ~/tmp
        hg clone https://bitbucket.org/birkenfeld/sphinx-contrib
        ## hg clone ssh://hg@bitbucket.org/birkenfeld/sphinx-contrib
        popd
    fi
    if [ -d ~/tmp/sphinx-contrib ] ;then
        pushd ~/tmp/sphinx-contrib
        cd sphinx-contrib/scaladomain
        python setup.py install
        popd
    fi
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
  $cmd
fi
