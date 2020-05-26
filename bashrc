#!/bin/bash

dir=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
export PATH=${PATH}:/opt/bin

# Run custom scripts before running initialization scripts
[[ -x ~/.bashrc.scripts.before ]] && source ~/.bashrc.scripts.before

# Run initialization scripts
for script in $dir/bash_*.sh ;do
    if [ -f $script ]; then
        echo "sourcing $script"
        source $script
    fi
done

# Run custom scripts after running initialization scripts
[[ -x ~/.bashrc.scripts.after ]] && source ~/.bashrc.scripts.after


##FIXME: this is a temporary hack
if [[ -d ~/.bashrc-scripts/installed/ ]] ;then
  for script in $(find ~/.bashrc-scripts/installed/ -type f | sort --reverse) ;do
    chmod 755 $script
    echo "activating $script"
    source $script
  done
fi

##FIXME: this is a temporary fix for snaps not being found. See: https://www.youtube.com/watch?v=2g-teghxI2A 
if [ -d /var/lib/snapd/desktop/applications ] ;then
  find -L ~/.local/share/applications -type l -delete
  ln -sf /var/lib/snapd/desktop/applications/*.desktop ~/.local/share/applications/
fi

# define prompt
if [ -x /usr/bin/dircolors ]; then
    export PS1='\[\033[01;31m\][$(date "+%Y-%m-%d %H:%M:%S")]\[\033[00m\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\] \u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    export PS1='[$(date "+%Y-%m-%d %H:%M:%S")]${debian_chroot:+($debian_chroot)} \u@\h:\w\$ '
fi

# Define history processing
mkdir -p $HOME/.bash_history+
export HISTSIZE=100000
export HISTFILESIZE=-1
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
export HISTCONTROL=ignorespace
export HISTIGNORE=ls:ps
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}"'echo $$ "$(history 1)" >> $HOME/.bash_history+/$(date +%Y%m%d)'
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s cmdhist
alias history+='find $HOME/.bash_history+ -type f | xargs grep'
