#!/bin/bash -x

# Sphinx is employed by Linux kernel and so do we: https://www.youtube.com/watch?v=jY_C-Z0qMSo
# see: https://downloads.lightbend.com/paradox/akka-docs-new/20170510-wip/scala/dev/documentation.html

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
