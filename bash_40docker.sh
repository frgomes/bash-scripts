#!/bin/bash

DOCKER_JUPYTER_PORT=18888
DOCKER_VNC_PORT=55901

function docker_jessie_torch7 {
    docker run -it --rm \
	       -p ${DOCKER_JUPYTER_PORT}:8888 \
               -v ${HOME}/Documents:/root/Documents \
               -v ${HOME}/Media:/root/Media \
               -v ${HOME}/workspace:/root/workspace \
               rgomes/jessie-torch7 $*
}

function docker_stretch_base {
  docker run -it --rm rgomes/stretch-base $*
}
function docker_sid_base {
  docker run -it --rm rgomes/sid-base $*
}

function docker_sid_kde_minimal {
  docker run -it --rm \
             -p ${DOCKER_VNC_PORT}:5901 \
             -v ${HOME}/Documents:/root/Documents \
             -v ${HOME}/Media:/root/Media \
             rgomes/sid-kde-minimal $*
}

function docker_sid_kde_standard {
  docker run -it --rm \
             -p ${DOCKER_VNC_PORT}:5901 \
             -v ${HOME}/Documents:/root/Documents \
             -v ${HOME}/Media:/root/Media \
             rgomes/sid-kde-standard $*
}

function docker_sid_kde_full {
  docker run -it --rm \
             -p ${DOCKER_VNC_PORT}:5901 \
             -v ${HOME}/Documents:/root/Documents \
             -v ${HOME}/Media:/root/Media \
             rgomes/sid-kde-full $*
}

function docker_sid_kdenlive {
  [[ ! -d $HOME/kdenlive ]] && mkdir -p $HOME/kdenlive
  docker run -it --rm \
             -p ${DOCKER_VNC_PORT}:5901 \
             -v ${HOME}/kdenlive:/root/kdenlive \
             -v ${HOME}/Documents:/root/Documents \
             -v ${HOME}/Media:/root/Media \
             rgomes/sid-kdenlive $*
}
