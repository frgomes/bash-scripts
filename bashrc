#!/bin/bash

##########################################
## Source this file from your ~/.bashrc ##
##########################################

dir=$(dirname $(test -L "$BASH_SOURCE" && readlink -f "$BASH_SOURCE" || echo "$BASH_SOURCE"))

[[ -x ~/.bashrc.scripts.before ]] && source ~/.bashrc.scripts.before

export PATH=~/bin:/opt/bin:${PATH}

for script in $dir/bash_*.sh ;do
    if [ -f $script ]; then
        echo "sourcing $script"
        source $script
    fi
done

[[ -x ~/.bashrc.scripts.after ]] && source ~/.bashrc.scripts.after

# Make sure these variables are defined ONLY ONCE and only ONLY HERE.
export HISTSIZE=20000
export HISTFILESIZE=20000
export HISTTIMEFORMAT="%Y%m%d_%H%M%S "
export HISTCONTROL=ignoredups:erasedups
export PROMPT_COMMAND='history -a'
shopt -s histappend
