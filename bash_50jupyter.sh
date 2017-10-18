#!/bin/bash


function jupyter_start {
  if [ ! -d $HOME/workspace/jupyter-notebooks ] ;then
    [[ ! -d $HOME/workspace ]] && mkdir -p $HOME/workspace
    pushd $HOME/workspace
    git clone http://github.com/frgomes/jupyter-notebooks
    popd
  fi
  pushd $HOME/workspace/jupyter-notebooks
  jupyter notebook
  popd
}
