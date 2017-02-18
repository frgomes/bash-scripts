#!/bin/bash

##################################################################################
#                                                                                #
# This is a very simple replacement for Debian package python-virtualenv.        #
#                                                                                #
# The aim is avoid the long list of transient dependencies pulled out, including #
# development tools, which are not desired on production servers.                #
#                                                                                #
##################################################################################
function workon() {
    if [ ! -z "$1" -a -d ~/.virtualenvs/"$1" ] ;then
        for script in activate postactivate ;do
            if [ -f ~/.virtualenvs/"$1"/bin/$script ] ;then
                local __shopts=$( echo $- | tr -d is); set +eu; source ~/.virtualenvs/"$1"/bin/$script; set -${__shopts}
                PS1='[$(date +%H:%M:%S)]'"($1)"${PS1}
            fi
        done
    else
        echo ~/.virtualenvs/"$1": virtualenv not found
        return 1
    fi
}

function deactivate() {
  PATH=${workon_PATH}
  PS1=${workon_PS1}
}

workon_PATH=$PATH
workon_PS1=$PS1
