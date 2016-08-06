#!/bin/bash


function jupyter() {
  mkdir -p ~/Documents/jupyter-notebooks > /dev/null
  pushd ~/Documents/jupyter-notebooks
  ipython notebook
  popd
}
