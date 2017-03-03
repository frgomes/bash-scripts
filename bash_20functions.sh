#!/bin/bash

##
# Utility logging functions
#

function trace { export _V=5; }
function fatal { export _V=4; }
function error { export _V=3; }
function warn  { export _V=2; }
function info  { export _V=1; }
function debug { export _V=0; }

warn

function _log() {
  level=$1
  shift
  if [[ $level -ge $_V ]]; then
    echo "$@"
  fi
}
_trace() { _log 5 "TRACE: $@"; } # Always prints
_fatal() { _log 4 "FATAL: $@"; }
_error() { _log 3 "ERROR: $@"; }
_warn()  { _log 2 "WARN:  $@"; }
_info()  { _log 1 "INFO:  $@"; }
_debug() { _log 0 "DEBUG: $@"; }


##
# Employs wget in order to download a file into directory ${HOME}/Downloads
#
# @param url:    source URL
# @param cookie: (optional) cookie to be employed in case authorization is required
#
function download {
  local url="$1"
  local cookie="$2"

  if [ ! -z "$1" ] ;then
    local dst=${dst:=$(basename $url)}
    pushd ${HOME}/Downloads > /dev/null 2>&1
    if [ ! -f ${dst} ] ;then
      if [ -z "$cookie" ] ;then
        wget --quiet -O "${dst}" "${url}"
      else
        _info wget --quiet --no-cookies --no-check-certificate --header "Cookie: ${cookie}" "${url}"
        wget --quiet --no-cookies --no-check-certificate --header "Cookie: ${cookie}" "${url}"
      fi
    fi
    popd > /dev/null 2>&1
  fi
}


function download_with_cookie_java {
  local url="$1"

  if [ ! -z "$1" ] ;then
    download $url "gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"
  fi
}


function zap {
  local args=$@
  cmd=${args:=xargs rm -r -f}
  find . -maxdepth 2 -type d \( -name target -o -name target_sbt -o -name .ensime_cache \) | $cmd
  find .             -type d \( -name target -o -name target_sbt -o -name .ensime_cache \) | $cmd
  find . -type f \( -name \~ -o -name '*~' \) | $cmd
}


function backup {
  now=`date +%Y%m%d_%H%M%S`

  cwd="$1"
  cwd=${cwd:=$(pwd)}

  if [ -d "$cwd" ] ;then
      dir="$( readlink -f "$cwd" )"
      dst=${HOME}/backup/archives"${dir}"
      name="$( basename "$dir" )"
      mkdir -p ${dst} > /dev/null 2>&1
      echo "$dir" ...
      archive=${dst}/${now}_${name}.tar.bz2
      echo "${archive}"

      tar cpJf ${archive} ${dir} --exclude=${dir}/node_modules --exclude-vcs

      # copy to Dropbox, if available
      replica=${HOME}/Dropbox/Private/backup/"${dst}"
      mkdir -p "${replica}" > /dev/null 2>&1
      if [ $? -eq 0 ] ;then
          cp ${archive} "${replica}"
      fi
  fi
}


function backup_zip {
  now=`date +%Y%m%d_%H%M%S`

  cwd="$1"
  cwd=${cwd:=$(pwd)}

  if [ -d "$cwd" ] ;then
      dir="$( readlink -f "$cwd" )"
      dst=${HOME}/backup/archives"${dir}"
      name="$( basename "$dir" )"
      mkdir -p ${dst} > /dev/null 2>&1
      echo "$dir" ...
      archive=${dst}/${now}_${name}.zip
      zip -q -r ${archive} ${dir} -x ${dir}/.idea\* -x ${dir}/.hg/\* -x ${dir}/.git/\* -x ${dir}/.lib/\* -x ${dir}/node_modules/
      echo "${archive}"

      # copy to Dropbox, if available
      replica=${HOME}/Dropbox/Private/backup/"${dst}"
      mkdir -p "${replica}" > /dev/null 2>&1
      if [ $? -eq 0 ] ;then
          cp ${archive} "${replica}"
      fi
  fi
}


function workspace() {
  local dir=${WORKSPACE:=$HOME/workspace}
  cd ${dir}/$1
}

function _complete_workspace() {
  local cur prev opts base
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts=""

  local dir=${WORKSPACE:=$HOME/workspace}
  local projects=$( ls -p ${dir} | fgrep / | sed 's:/::' | grep -v -E -e '[.]OLD$' | grep -v -E -e '[.]DELETE-ME$' )
  COMPREPLY=( $(compgen -W "${projects}" -- ${cur}) )
  return 0
}
complete -F _complete_workspace workspace
