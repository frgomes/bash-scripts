#!/bin/bash

function install_emacs_requirements {
    sudo apt install -y build-essential gcc git-core texinfo libncurses5-dev
}

function install_emacs_download {
    [[ ! -d ~/workspace ]] && mkdir -p ~/workspace
    pushd ~/workspace

    if [ ! -d emacs ] ;then
        git clone git://git.savannah.gnu.org/emacs.git
    else
        cd emacs
        git pull
    fi
    git checkout emacs-26.3

    popd
}

function install_emacs_make {
  if [ -d ~/workspace/emacs ] ;then
      cd ~/workspace/emacs && \
        ./autogen.sh && \
          ./configure --without-x --prefix=/opt/emacs && \
            make && \
      return 0
  else
      return 1
  fi
}


function install_emacs_make_install {
    sudo make install
}


function install_emacs {
    pushd $HOME
    install_emacs_requirements && \
        install_emacs_download && \
        install_emacs_make && \
        install_emacs_make_install
    popd
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
