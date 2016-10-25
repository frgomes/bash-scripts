#!/bin/bash

function docker_jessie_torch7 {
    docker run -it --rm \
	       -p 18888:8888 \
               -v ${HOME}/Documents:/root/Documents \
               -v ${HOME}/Media:/root/Media \
               -v ${HOME}/workspace:/root/workspace \
               rgomes/jessie-torch7 $*
}

function docker_stretch_base {
  docker run -it --rm rgomes/stretch-base $*
}

function docker_stretch_kde_minimal {
  # You may or may not have a xrdp already installed and kicking in your host computer.
  # In a clean setup, you should not. However, you may be in a transitioning state which
  # implies that your host computer still have a lot of things installed which should not
  # be installed in a clean container host. In this case, we should employ something
  # different from the default port 3389.
  XRDP_PORT=53389
  docker run -it --rm \
             -p ${XRDP_PORT}:3389 \
             -v ${HOME}/Documents:/root/Documents \
             -v ${HOME}/Media:/root/Media \
             rgomes/stretch-kde-minimal $*
}

function docker_stretch_kde_standard {
  # You may or may not have a xrdp already installed and kicking in your host computer.
  # In a clean setup, you should not. However, you may be in a transitioning state which
  # implies that your host computer still have a lot of things installed which should not
  # be installed in a clean container host. In this case, we should employ something
  # different from the default port 3389.
  XRDP_PORT=53389
  docker run -it --rm \
             -p ${XRDP_PORT}:3389 \
             -v ${HOME}/Documents:/root/Documents \
             -v ${HOME}/Media:/root/Media \
             rgomes/stretch-kde-standard $*
}

function docker_stretch_kde_full {
  # You may or may not have a xrdp already installed and kicking in your host computer.
  # In a clean setup, you should not. However, you may be in a transitioning state which
  # implies that your host computer still have a lot of things installed which should not
  # be installed in a clean container host. In this case, we should employ something
  # different from the default port 3389.
  XRDP_PORT=53389
  docker run -it --rm \
             -p ${XRDP_PORT}:3389 \
             -v ${HOME}/Documents:/root/Documents \
             -v ${HOME}/Media:/root/Media \
             rgomes/stretch-kde-full $*
}

function docker_stretch_kdenlive {
  # You may or may not have a xrdp already installed and kicking in your host computer.
  # In a clean setup, you should not. However, you may be in a transitioning state which
  # implies that your host computer still have a lot of things installed which should not
  # be installed in a clean container host. In this case, we should employ something
  # different from the default port 3389.
  XRDP_PORT=53389
  [[ ! -d $HOME/kdenlive ]] && mkdir -p $HOME/kdenlive
  docker run -it --rm \
             -p ${XRDP_PORT}:3389 \
             -v ${HOME}/kdenlive:/root/kdenlive \
             -v ${HOME}/Documents:/root/Documents \
             -v ${HOME}/Media:/root/Media \
             rgomes/stretch-kdenlive $*
}
