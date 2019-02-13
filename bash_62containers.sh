#!/bin/bash

DOCKER_JUPYTER_PORT=18888
DOCKER_X2GO_PORT=${DOCKER_X2GO_PORT:=22}

WORK_DOCUMENTS=${HOME}/Documents
WORK_MEDIA=${HOME}/Media
WORK_WORKSPACE=${HOME}/workspace



function containers_run_jessie_torch7 {
    docker run -it --rm \
	       -p ${DOCKER_JUPYTER_PORT}:8888 \
               -v ${WORK_DOCUMENTS}:/root/Documents \
               -v ${WORK_MEDIA}:/root/Media \
               -v ${WORK_WORKSPACE}:/root/workspace \
               rgomes/jessie-torch7 $*
}


function containers_run_base {
  docker run -it --rm rgomes/debian-base $*
}

function containers_run_xfce4 {
  docker run -it --rm \
             -p ${DOCKER_X2GO_PORT}:22 \
             rgomes/xfce4 $*
}

function containers_run_openbox {
  docker run -it --rm \
             -p ${DOCKER_X2GO_PORT}:22 \
             -v ${WORK_DOCUMENTS}:/home/x2go/Documents \
             -v ${WORK_MEDIA}:/home/x2go/Media \
             -v ${WORK_WORKSPACE}:/home/x2go/workspace \
             rgomes/openbox $*
}

function containers_run_standard {
  docker run -it --rm \
             -p ${DOCKER_X2GO_PORT}:22 \
             -v ${WORK_DOCUMENTS}:/home/x2go/Documents \
             -v ${WORK_MEDIA}:/home/x2go/Media \
             -v ${WORK_WORKSPACE}:/home/x2go/workspace \
             rgomes/kde-standard $*
}

function containers_run_kdenlive {
  [[ ! -d $HOME/kdenlive ]] && mkdir -p $HOME/kdenlive
  docker run -it --rm \
             -p ${DOCKER_X2GO_PORT}:22 \
             -v ${HOME}/kdenlive:/home/x2go/kdenlive \
             -v ${WORK_DOCUMENTS}:/home/x2go/Documents \
             -v ${WORK_MEDIA}:/home/x2go/Media \
             -v ${WORK_WORKSPACE}:/home/x2go/workspace \
             rgomes/kdenlive $*
}
