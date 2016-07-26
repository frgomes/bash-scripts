#!/bin/bash

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
      tar cpJf ${archive} ${dir}

      # copy to Dropbox, if available
      replica=${HOME}/Dropbox/Private/backup/"${dst}"
      mkdir -p "${replica}" > /dev/null 2>&1
      if [ $? -eq 0 ] ;then
          cp ${archive} "${replica}"
      fi

      echo "${archive}"
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
      zip -q -r ${archive} ${dir} -x ${dir}/.idea\* -x ${dir}/.hg/\* -x ${dir}/.git/\* -x ${dir}/.lib/\*

      # copy to Dropbox, if available
      replica=${HOME}/Dropbox/Private/backup/"${dst}"
      mkdir -p "${replica}" > /dev/null 2>&1
      if [ $? -eq 0 ] ;then
          cp ${archive} "${replica}"
      fi

      echo "${archive}"
  fi
}
