#!/bin/bash

DOCKER_JUPYTER_PORT=18888
DOCKER_X2GO_PORT=${DOCKER_X2GO_PORT:=22}

WORK_DOCUMENTS=${HOME}/Documents
WORK_MEDIA=${HOME}/Media
WORK_WORKSPACE=${HOME}/workspace



function containers_jessie_torch7 {
    docker run -it --rm \
	       -p ${DOCKER_JUPYTER_PORT}:8888 \
               -v ${WORK_DOCUMENTS}:/root/Documents \
               -v ${WORK_MEDIA}:/root/Media \
               -v ${WORK_WORKSPACE}:/root/workspace \
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
             -v ${WORK_DOCUMENTS}:/home/x2go/Documents \
             -v ${WORK_MEDIA}:/home/x2go/Media \
             -v ${WORK_WORKSPACE}:/home/x2go/workspace \
             rgomes/openbox $*
}

function containers_rgomes_kde_standard {
  docker run -it --rm \
             -p ${DOCKER_X2GO_PORT}:22 \
             -v ${WORK_DOCUMENTS}:/home/x2go/Documents \
             -v ${WORK_MEDIA}:/home/x2go/Media \
             -v ${WORK_WORKSPACE}:/home/x2go/workspace \
             rgomes/kde-standard $*
}

function containers_rgomes_kdenlive {
  [[ ! -d $HOME/kdenlive ]] && mkdir -p $HOME/kdenlive
  docker run -it --rm \
             -p ${DOCKER_X2GO_PORT}:22 \
             -v ${HOME}/kdenlive:/home/x2go/kdenlive \
             -v ${WORK_DOCUMENTS}:/home/x2go/Documents \
             -v ${WORK_MEDIA}:/home/x2go/Media \
             -v ${WORK_WORKSPACE}:/home/x2go/workspace \
             rgomes/kdenlive $*
}

function containers_debian_buster {
  docker run -it $* debian:buster /bin/bash
}


function docker_start_suitecrm {
  ## see: https://github.com/bitnami/bitnami-docker-suitecrm
   
  ## You can have up to 53 services in a single box, numbered from 11 to 63.
  ## Each container can use up to 1000 port number in a given range nn000 to nn999.
  local container_number=11

  if [ $(docker network list | fgrep suitecrm-tier > /dev/null; echo $?) == 1 ] ;then 
    echo docker network create suitecrm-tier
    docker network create suitecrm-tier
  fi

  if [ $(docker volume list | fgrep suitecrm > /dev/null; echo $?) == 1 ] ;then 
    echo docker volume create --name suitecrm
    docker volume create --name suitecrm
  fi

  local mariadb=$(docker container list --all | fgrep mariadb | sed -E 's/[\t ]+/ /g' | cut -d' ' -f1)
  if [ ! -z ${mariadb} ] ;then
    docker container start ${mariadb}
  else 
    docker run -d --name mariadb \
      -e ALLOW_EMPTY_PASSWORD=yes \
      -e MARIADB_USER=bn_suitecrm \
      -e MARIADB_DATABASE=bitnami_suitecrm \
      --net suitecrm-tier \
      --mount type=volume,source=suitecrm,target=/bitnami \
      bitnami/mariadb:latest
  fi

  local suitecrm=$(docker container list -all | fgrep suitecrm | sed -E 's/[\t ]+/ /g' | cut -d' ' -f1)
  if [ ! -z ${suitecrm} ] ;then
    docker container start ${suitecrm}
  else 
    docker run -d --name suitecrm -p ${container_number}080:80 -p ${container_number}443:443 \
      -e SUITECRM_USERNAME=${USER} \
      -e SUITECRM_DATABASE_USER=bn_suitecrm \
      -e SUITECRM_DATABASE_NAME=bitnami_suitecrm \
      -e ALLOW_EMPTY_PASSWORD=yes \
      --net suitecrm-tier \
      --mount type=volume,source=suitecrm,target=/bitnami \
      bitnami/suitecrm:latest
  fi

  echo '***************************************************************'
  echo "SuiteCRM available at http://localhost:${container_number}080/"
  echo "  username: ${USER}"
  echo "  default password: bitnami"
  echo '***************************************************************'
}

function docker_stop_suitecrm {
  local mariadb=$(docker container list | fgrep mariadb | sed -E 's/[\t ]+/ /g' | cut -d' ' -f1)
  if [ ! -z ${mariadb} ] ;then
    docker container stop ${mariadb}
  fi

  local suitecrm=$(docker container list | fgrep suitecrm | sed -E 's/[\t ]+/ /g' | cut -d' ' -f1)
  if [ ! -z ${suitecrm} ] ;then
    docker container stop ${suitecrm}
  fi
}

function docker_backup_suitecrm {
  mkdir -p ~/tmp ~/Dropbox/containers
  sudo tar cpf ~/tmp/suitecrm.tar.xz /home/docker/volumes/suitecrm
  sudo chown $USER:$USER ~/tmp/suitecrm.tar.xz
  mv ~/tmp/suitecrm.tar.xz ~/Dropbox/containers
}
