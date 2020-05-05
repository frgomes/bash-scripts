#!/bin/bash

DOCKER_JUPYTER_PORT=${DOCKER_JUPYTER_PORT:=18888}
DOCKER_X2GO_PORT=${DOCKER_X2GO_PORT:=22}


function containers_jessie_torch7 {
    docker run -it --rm \
	       -p ${DOCKER_JUPYTER_PORT}:8888 \
               -v "${DOCUMENTS}":/root/Documents \
               -v "${MEDIA}":/root/Media \
               -v "${WORKSPACE}":/root/workspace \
               rgomes/jessie-torch7 $*
}


function containers_rgomes_debian_base {
  docker run -it --rm rgomes/debian-base $*
}

function containers_rgomes_xfce4 {
  docker run -it --rm \
             -p ${DOCKER_X2GO_PORT}:22 \
             rgomes/xfce4 $*
}

function containers_rgomes_openbox {
  docker run -it --rm \
             -p ${DOCKER_X2GO_PORT}:22 \
             -v "${DOCUMENTS}":/home/x2go/Documents \
             -v "${MEDIA}":/home/x2go/Media \
             -v "${WORKSPACE}":/home/x2go/workspace \
             rgomes/openbox $*
}

function containers_rgomes_kde_standard {
  docker run -it --rm \
             -p ${DOCKER_X2GO_PORT}:22 \
             -v "${DOCUMENTS}":/home/x2go/Documents \
             -v "${MEDIA}":/home/x2go/Media \
             -v "${WORKSPACE}":/home/x2go/workspace \
             rgomes/kde-standard $*
}

function containers_rgomes_kdenlive {
  [[ ! -d $HOME/kdenlive ]] && mkdir -p $HOME/kdenlive
  docker run -it --rm \
             -p ${DOCKER_X2GO_PORT}:22 \
             -v "${HOME}"/kdenlive:/home/x2go/kdenlive \
             -v "${DOCUMENTS}":/home/x2go/Documents \
             -v "${MEDIA}":/home/x2go/Media \
             -v "${WORKSPACE}":/home/x2go/workspace \
             rgomes/kdenlive $*
}

function containers_debian_buster {
  docker run -it $* debian:buster /bin/bash
}
