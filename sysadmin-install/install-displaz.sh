#!/bin/bash

function install_displaz_requirements {
    ##TODO: centos: installed git gcc-c++ make patch cmake qt5-qtbase-devel python3-docutils
    sudo aptitude install -y git g++ cmake qt5-default python3-docutils
}

function install_displaz_download {
    [[ ! -d "${WORKSPACE}" ]] && mkdir -p "${WORKSPACE}"
    pushd "${WORKSPACE}"

    if [ ! -d displaz ] ;then
        git clone https://github.com/c42f/displaz.git
    else
        cd displaz
        git pull
    fi

    popd
}

function install_displaz_make {
  if [ -d "${WORKSPACE}"/displaz ] ;then
      cd "${WORKSPACE}"/displaz && \
        if [ ! -d build_external ] ;then mkdir build_external ;fi && \
          cd build_external && \
            cmake ../thirdparty/external && \
              make -j4 && \
                cd .. && \
                  if [ ! -d build ] ;then mkdir build ;fi && \
                    cd build && \
                      cmake .. && \
                        make -j4 && \
                         sudo make install
  else
      return 1
  fi
}

function install_displaz {
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd $*
  done
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(grep -E "^function " $self | cut -d' ' -f2 | tail -1)
  $cmd $*
fi
