#!/bin/bash

##################################################################################
# This script allows management of multiple virtual environments.                #
# There are two ways of doing this:                                              #
#  1. employ Python virtualenv and virtualenvwrapper; (HIGHLY PREFERABLE)        #
#  2. employ simplistic shell scripts, which are independent of Python.          #
##################################################################################

export WORKON_HOME=$HOME/.virtualenvs

if [[ -f /usr/share/virtualenvwrapper/virtualenvwrapper.sh ]] ;then
  [[ ! -d ${WORKON_HOME} ]] && mkdir -p ${WORKON_HOME}
  source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
else
  ###################################################################################
  #                                                                                 #
  # This is a very simple 'replacement' for Debian package python-virtualenv.       #
  #                                                                                 #
  # The aim is avoid the long list of transitive dependencies pulled out, including #
  # development tools, which are not desired in production servers.                 #
  #                                                                                 #
  ###################################################################################
  function workon() {
      if [ ! -z "$1" -a -d ${WORKON_HOME}/"$1" ] ;then
          if [ -f ${WORKON_HOME}/"$1"/bin/postactivate ] ;then
              local __shopts=$(echo $- | tr -d is); set +eu; source ${WORKON_HOME}/"$1"/bin/postactivate; set -${__shopts}
              PS1="($1) "${PS1}
          fi
      else
          echo ${WORKON_HOME}/"$1": virtualenv not found
          return 1
      fi
  }
  
  function deactivate() {
    PATH=${workon_PATH}
    PS1=${workon_PS1}
  }
  
  workon_PATH=$PATH
  workon_PS1=$PS1
fi
