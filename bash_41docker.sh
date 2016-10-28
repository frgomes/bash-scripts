#!/bin/bash

DOCKER_JUPYTER_PORT=18888
DOCKER_VNC_PORT=55901

WORK_DOCUMENTS=${HOME}/Documents
WORK_MEDIA=/media/b1582a88-e1e6-413d-bcac-881206487eb6
WORK_WORKSPACE=${HOME}/workspace



function docker_run_jessie_torch7 {
    docker run -it --rm \
	       -p ${DOCKER_JUPYTER_PORT}:8888 \
               -v ${WORK_DOCUMENTS}:/root/Documents \
               -v ${WORK_MEDIA}:/root/Media \
               -v ${WORK_WORKSPACE}:/root/workspace \
               rgomes/jessie-torch7 $*
}

function docker_run_stretch {
  docker run -it --rm rgomes/stretch-base $*
}

function docker_run_sid {
  docker run -it --rm rgomes/sid-base $*
}

function docker_run_minimal {
  docker run -it --rm \
             -p ${DOCKER_VNC_PORT}:5901 \
             -v ${WORK_DOCUMENTS}:/root/Documents \
             -v ${WORK_MEDIA}:/root/Media \
             rgomes/sid-kde-minimal $*
}

function docker_run_standard {
  docker run -it --rm \
             -p ${DOCKER_VNC_PORT}:5901 \
             -v ${WORK_DOCUMENTS}:/root/Documents \
             -v ${WORK_MEDIA}:/root/Media \
             rgomes/sid-kde-standard $*
}

function docker_run_full {
  docker run -it --rm \
             -p ${DOCKER_VNC_PORT}:5901 \
             -v ${WORK_DOCUMENTS}:/root/Documents \
             -v ${WORK_MEDIA}:/root/Media \
             rgomes/sid-kde-full $*
}

function docker_run_kdenlive {
  [[ ! -d $HOME/kdenlive ]] && mkdir -p $HOME/kdenlive
  docker run -it --rm \
             -p ${DOCKER_VNC_PORT}:5901 \
             -v ${HOME}/kdenlive:/root/kdenlive \
             -v ${WORK_DOCUMENTS}:/root/Documents \
             -v ${WORK_MEDIA}:/root/Media \
             rgomes/sid-kdenlive $*
}
