#!/bin/bash

##########################################################################
# This script allows switching among multiple virtual environments.      #
#                                                                        #
# The intent is providing function ``workon`` in the absence of packages #
#   * virtualenv                                                         #
#   * virtualenvwrapper                                                  #
##########################################################################

export WORKON_HOME=$HOME/.virtualenvs

if [[ -f /usr/share/virtualenvwrapper/virtualenvwrapper.sh ]] ;then
  [[ ! -d ${WORKON_HOME} ]] && mkdir -p ${WORKON_HOME}
  source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
else
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
