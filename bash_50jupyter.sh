#!/bin/bash


function jupyter_start {
  if [ ! -d "${WORKSPACE}"/jupyter-notebooks ] ;then
    [[ ! -d "${WORKSPACE}" ]] && mkdir -p "${WORKSPACE}"
    pushd "${WORKSPACE}"
    git clone http://github.com/frgomes/jupyter-notebooks
    popd
  fi
  pushd "${WORKSPACE}"/jupyter-notebooks
  jupyter notebook
  popd
}
