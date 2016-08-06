#!/bin/bash

##########################################
## Source this file from your ~/.bashrc ##
##########################################

dir=$(dirname $(test -L "$BASH_SOURCE" && readlink -f "$BASH_SOURCE" || echo "$BASH_SOURCE"))

for script in $dir/bash_*.sh ;do
    if [ -f $script ]; then
        echo "sourcing $script"
        source $script
    fi
done

export PATH=~/bin:${PATH}


# Make sure these variables are defined ONLY ONCE and only ONLY HERE.
shopt -s histappend
HISTSIZE=50000
HISTTIMEFORMAT="%Y%m%d_%H%M%S "
##HISTFILESIZE= # Does not truncate file size

workon j8s11
