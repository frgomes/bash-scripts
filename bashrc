#!/bin/bash -e

dir=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
echo $PATH | tr ':' '\n' | grep -E "^${dir}$" || export PATH="${dir}/bin":$PATH


## A minimal Python installation should be available in your distribution in general.
## However, we simply skip this entire business in case Python is missing.
function __bash_virtualenv_install_pip {
  if [[ ! -z $(which python) ]] ;then
    if [[ ! -e "${HOME}/.local/bin/pip" ]] ;then
      [[ ! -d "${DOWNLOADS}" ]] && mkdir -p "${DOWNLOADS}"
      [[ ! -f "${DOWNLOADS}/get-pip.py" ]] && wget https://bootstrap.pypa.io/get-pip.py -O "${DOWNLOADS}/get-pip.py"
   
      local -i v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
      if [ -e $(which python${v}) ] ;then
        python${v} "${DOWNLOADS}/get-pip.py" --user
      fi
    fi
  fi
}
function __bash_virtualenv_install_virtualenv {
  if [[ ! -z $(which python) ]] ;then
    if [[ ! -e "${HOME}/.local/bin/virtualenv" ]] ;then
      local -i v=$(python -V 2>&1 | cut -d' ' -f2 | cut -d. -f1)
      if [ -e $(which python${v}) ] ;then
        python${v} -m pip install --quiet --user --upgrade pip virtualenv virtualenvwrapper
      fi
    fi
  fi
  [[ -e "${HOME}/.local/bin/virtualenvwrapper.sh" ]] && source "${HOME}/.local/bin/virtualenvwrapper.sh"
}
function __bash_virtualenv_activate_virtualenv {
  [[ ! -z $(which python) ]] && [[ ! -z "$1" ]] && workon "$1"
}
__bash_virtualenv_install_pip
__bash_virtualenv_install_virtualenv
__bash_virtualenv_activate_virtualenv "$1"

# AUTO-MIGRATION
[[ ! -d "$HOME/.bashrc-scripts" ]] && mkdir -p "$HOME/.bashrc-scripts"
[[ -f "$HOME/.bashrc.scripts.before" ]] && mv "$HOME/.bashrc.scripts.before" "$HOME/.bashrc-scripts/head"
[[ -f "$HOME/.bashrc.scripts.after" ]]  && mv "$HOME/.bashrc.scripts.after"  "$HOME/.bashrc-scripts/tail"

# Run custom scripts before running initialization scripts
[[ ! -d "${VIRTUAL_ENV:-${HOME}}/.bashrc-scripts" ]] && mkdir -p "${VIRTUAL_ENV:-${HOME}}/.bashrc-scripts"
[[ -x "${VIRTUAL_ENV:-${HOME}}/.bashrc-scripts/head" ]] && source "${VIRTUAL_ENV:-${HOME}}/.bashrc-scripts/head"

# Define notable locations
export DOWNLOADS="${DOWNLOADS:=${HOME}/Downloads}"
export DOCUMENTS="${DOCUMENTS:=${HOME}/Documents}"
export MEDIA="${MEDIA:=${HOME}/Media}"
export SOFTWARE="/mnt/omv/Software"
export WORKSPACE="${WORKSPACE:=${HOME}/workspace}"
export WORKON_HOME="${WORKON_HOME:=${HOME}/.virtualenvs}"
export TOOLS_HOME="${TOOLS_HOME:=$HOME/tools}"

# Run initialization scripts
for script in ${VIRTUAL_ENV:-"${HOME}"}/.bashrc-scripts/installed/*.sh ;do
    if [ -f $script ]; then
        echo "sourcing $script"
        source $script
    fi
done

##XXX: Legacy: Run initialization scripts
for script in ${dir}/bash_*.sh ;do
    if [ -f $script ]; then
        echo "sourcing $script"
        source $script
    fi
done

# Run custom scripts after running initialization scripts
[[ -x "${VIRTUAL_ENV:-${HOME}}/.bashrc-scripts/tail" ]] && source "${VIRTUAL_ENV:-${HOME}}/.bashrc-scripts/tail"


##FIXME: this is a temporary fix for snaps not being found. See: https://www.youtube.com/watch?v=2g-teghxI2A 
if [ -d /var/lib/snapd/desktop/applications ] ;then
  find -L ~/.local/share/applications -type l -delete
  ln -sf /var/lib/snapd/desktop/applications/*.desktop ~/.local/share/applications/
fi

##FIXME: enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

##FIXME: essential
alias cd='cd -P'
alias la='ls -alL'
alias ll='ls -lhL'
alias lt='ls -lhtL'
alias df='df -h'
alias du='du -h'

##FIXME: the obligatory Emacs (or its surrogate...)
if [ ! -z $(which emacs) ] ;then
  VISUAL=emacs
  EDITOR=emacs
  ALTERNATE_EDITOR=emacs
else
  VISUAL=zile
  EDITOR=zile
  ALTERNATE_EDITOR=zile
fi
export VISUAL EDITOR ALTERNATE_EDITOR

##FIXME: viewing files nicely
export LESS=' -R '
export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'
export LESSCLOSE='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s %s'
export VIEWER=less

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
