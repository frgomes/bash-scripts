#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[ -z "$PS1" ] && return


function __bash_path_prepend() {
  [[ ! -z "$1" ]] && echo "$PATH" | tr ':' '\n' | grep -F "$1" > /dev/null || export PATH="$1:${PATH}"
}
function __bash_path_append() {
  [[ ! -z "$1" ]] && echo "$PATH" | tr ':' '\n' | grep -F "$1" > /dev/null || export PATH="${PATH}:$1"
}

__bash_path_prepend "${HOME}/bin"
__bash_path_prepend "$(dirname $(readlink -f "${BASH_SOURCE[0]}"))/sbin"
__bash_path_prepend "$(dirname $(readlink -f "${BASH_SOURCE[0]}"))/bin"
__bash_path_prepend "${HOME}/.local/share/../bin"

##FIXME: choose text editor on this order: emacs, zile, vim, nano, vi
if [ ! -z $(which emacs 2> /dev/null) ] ;then
  VISUAL=emacs
  EDITOR="zile"
  ALTERNATE_EDITOR="vi -e"
elif [ ! -z $(which zile 2> /dev/null) ] ;then
  VISUAL=emacs
  EDITOR="zile"
  ALTERNATE_EDITOR="vi -e"
elif [ ! -z $(which vim 2> /dev/null) ] ;then
  VISUAL=vim
  EDITOR=vi
  ALTERNATE_EDITOR="vi -e"
elif [ ! -z $(which nano 2> /dev/null) ] ;then
  VISUAL=emacs
  EDITOR=nano
  ALTERNATE_EDITOR="vi -e"
else
  VISUAL=vim
  EDITOR=vi
  ALTERNATE_EDITOR="vi -e"
fi
export VISUAL EDITOR ALTERNATE_EDITOR

# define prompt
if [ -x /usr/bin/dircolors ]; then
    export PS1='\[\033[01;31m\][$(date "+%Y-%m-%d %H:%M:%S")]\[\033[00m\]>\[\033[01;32m\]$(scm_branch)\[\033[00m\]>\[\033[01;34m\]\u@\h:\w\[\033[00m\]\$ '
else
    export PS1='[$(date "+%Y-%m-%d %H:%M:%S")]>$(__scm_branch)>\u@\h:\w\$ '
fi

# Define notable locations
export DOWNLOADS="${DOWNLOADS:=${HOME}/Downloads}"
export DOCUMENTS="${DOCUMENTS:=${HOME}/Documents}"
export MEDIA="${MEDIA:=${HOME}/Media}"
export SOFTWARE="${SOFTWARE:=$HOME/Downloads}"
export WORKSPACE="${WORKSPACE:=${HOME}/workspace}"
export TOOLS_HOME="${TOOLS_HOME:=$HOME/tools}"

# Define history processing
# see also: bin/history+
mkdir -p "${HOME}"/.bash_history+
export HISTSIZE=100000
export HISTFILESIZE=-1
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
export HISTCONTROL=ignorespace
export HISTIGNORE=ls:ps
export PROMPT_COMMAND='printf "%+7s %s\n" ${$} "$(history 1)" >> "${HOME}/.bash_history+/$(date +%Y%m%d)"'
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s cmdhist
