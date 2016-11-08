#!/bin/bash


function jupyter() {
  if [ ! -d $HOME/workspace/jupyter-notebooks ] ;then
    [[ ! -d $HOME/workspace ]] && mkdir -p $HOME/workspace
    pushd $HOME/workspace
    git clohe http://github.com/frgomes/jupyter-notebooks
    popd
  fi
  pushd $HOME/workspace/jupyter-notebooks
  ipython notebook
  popd
}
