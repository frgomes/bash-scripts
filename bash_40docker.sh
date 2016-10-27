#!/bin/bash

DOCKER_JUPYTER_PORT=18888
DOCKER_VNC_PORT=55901

WORK_DOCUMENTS=${HOME}/Documents
WORK_MEDIA=/media/b1582a88-e1e6-413d-bcac-881206487eb6
WORK_WORKSPACE=${HOME}/workspace



function docker_jessie_torch7 {
    docker run -it --rm \
	       -p ${DOCKER_JUPYTER_PORT}:8888 \
               -v ${WORK_DOCUMENTS}:/root/Documents \
               -v ${WORK_MEDIA}:/root/Media \
               -v ${WORK_WORKSPACE}:/root/workspace \
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
             -v ${WORK_DOCUMENTS}:/root/Documents \
             -v ${WORK_MEDIA}:/root/Media \
             rgomes/sid-kde-minimal $*
}

function docker_sid_kde_standard {
  docker run -it --rm \
             -p ${DOCKER_VNC_PORT}:5901 \
             -v ${WORK_DOCUMENTS}:/root/Documents \
             -v ${WORK_MEDIA}:/root/Media \
             rgomes/sid-kde-standard $*
}

function docker_sid_kde_full {
  docker run -it --rm \
             -p ${DOCKER_VNC_PORT}:5901 \
             -v ${WORK_DOCUMENTS}:/root/Documents \
             -v ${WORK_MEDIA}:/root/Media \
             rgomes/sid-kde-full $*
}

function docker_sid_kdenlive {
  [[ ! -d $HOME/kdenlive ]] && mkdir -p $HOME/kdenlive
  docker run -it --rm \
             -p ${DOCKER_VNC_PORT}:5901 \
             -v ${HOME}/kdenlive:/root/kdenlive \
             -v ${WORK_DOCUMENTS}:/root/Documents \
             -v ${WORK_MEDIA}:/root/Media \
             rgomes/sid-kdenlive $*
}
