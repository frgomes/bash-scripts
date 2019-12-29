#!/bin/bash

##########################################
## Source this file from your ~/.bashrc ##
##########################################

dir=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))

[[ -x ~/.bashrc.scripts.before ]] && source ~/.bashrc.scripts.before

export PATH=/opt/bin:${PATH}

if [ -x /usr/bin/dircolors ]; then
    export PS1='\[\033[01;31m\][$(date +%Y%m%d-%H:%M:%S)]\[\033[00m\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    export PS1='[$(date +%Y%m%d-%H:%M:%S)]${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

for script in $dir/bash_*.sh ;do
    if [ -f $script ]; then
        echo "sourcing $script"
        source $script
    fi
done

#[[ ! -d ~/.bashrc-scripts/installed/ ]] && mkdir -p ~/.bashrc-scripts/installed/
#for script in $(find ~/.bashrc-scripts/installed/ -type f | sort --reverse) ;do
#  chmod 755 $script
#  source $script
#done

[[ -x ~/.bashrc.scripts.after ]] && source ~/.bashrc.scripts.after

# Make sure these variables are defined ONLY ONCE and only ONLY HERE.
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTTIMEFORMAT="%Y%m%d_%H%M%S "
export HISTCONTROL=ignorespace
export HISTIGNORE=ls:ps
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'n'}history -a; history -c; history -r"
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s cmdhist
