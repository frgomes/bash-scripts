#!/bin/bash -e


function __bash_path_prepend() {
  [[ ! -z "$1" ]] && echo "$PATH" | tr ':' '\n' | fgrep "$1" > /dev/null || export PATH="$1:${PATH}"
}
function __bash_path_append() {
  [[ ! -z "$1" ]] && echo "$PATH" | tr ':' '\n' | fgrep "$1" > /dev/null || export PATH="${PATH}:$1"
}

## install aptitude in order to add some compatibility layer among distributions
function __bash_aptitude_install {
  case "$(lsb_release -si)" in
    Debian)   which aptitude >/dev/null 2>&1 || sudo apt install -y aptitude;;
    openSUSE) which aptitude >/dev/null 2>&1 || sudo zypper install -y zypper-aptitude;;
  esac
}

## A minimal Python3 installation should be available in your distribution in general.
function __bash_virtualenv_install {
  which python3 >/dev/null 2>&1 || sudo aptitude install -y python3
  which pip3    >/dev/null 2>&1 || sudo aptitude install -y python3-pip
  which mkvirtualenv >/dev/null 2>&1 || python3 -m pip install --quiet --upgrade pip virtualenv virtualenvwrapper
  export VIRTUALENVWRAPPER_PYTHON=$(which python3)
  [[ -e "${HOME}/.local/bin/virtualenvwrapper.sh" ]] && source "${HOME}/.local/bin/virtualenvwrapper.sh"
}


dir=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
__bash_path_prepend "${dir}/bin"
__bash_path_prepend "${HOME}/.local/bin"
# __bash_path_prepend "${HOME}/bin"


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
if [ ! -z $(which zile) ] ;then
  VISUAL=emacs
  EDITOR="vi -e"
  ALTERNATE_EDITOR=zile
elif [ ! -z $(which nano) ] ;then
  VISUAL=emacs
  EDITOR="vi -e"
  ALTERNATE_EDITOR=nano
else
  VISUAL=emacs
  EDITOR="vi -e"
  ALTERNATE_EDITOR=vi
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

# Define notable locations
export DOWNLOADS="${DOWNLOADS:=${HOME}/Downloads}"
export DOCUMENTS="${DOCUMENTS:=${HOME}/Documents}"
export MEDIA="${MEDIA:=${HOME}/Media}"
export SOFTWARE="/mnt/omv/Software"
export WORKSPACE="${WORKSPACE:=${HOME}/workspace}"
export WORKON_HOME="${WORKON_HOME:=${HOME}/.virtualenvs}"
export TOOLS_HOME="${TOOLS_HOME:=$HOME/tools}"

# Define history processing
# see also: bin/history+
mkdir -p "${HOME}"/.bash_history+
export HISTSIZE=100000
export HISTFILESIZE=-1
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
export HISTCONTROL=ignorespace
export HISTIGNORE=ls:ps
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}"'echo $$ "$(history 1)" >> "${HOME}"/.bash_history+/$(date +%Y%m%d)'
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s cmdhist


# Create directory structure
for folder in "${HOME}"/.local/share/bash-scripts/{bin,postactivate/head.d,postactivate/postactivate.d,postactivate/tail.d} ;do
    [[ ! -d "${folder}" ]] && mkdir -p "${folder}"
done

##### AUTO-MIGRATION :: start
if [ -d "${HOME}"/.bashrc-scripts/installed ] ;then
    [[ -f "${HOME}"/.bashrc.scripts.before ]] && cp -vp "${HOME}"/.bashrc.scripts.before "${HOME}"/.local/share/bash-scripts/postactivate/head.d/000-default.sh
    [[ -f "${HOME}"/.bashrc.scripts.after ]]  && cp -vp "${HOME}"/.bashrc.scripts.after  "${HOME}"/.local/share/bash-scripts/postactivate/tail.d/999-default.sh
    find "${HOME}"/.bashrc-scripts/installed -type f | grep -E '.*[.]sh$' | while read script ;do
        cp -vp "${script}" "${HOME}"/.local/share/bash-scripts/postactivate/postactivate.d/
    done
fi   
##### AUTO-MIGRATION :: end


__bash_aptitude_install
__bash_virtualenv_install


if [ -z "$1" ] ;then
    "${dir}"/bin/bash_scripts_setup
    source "${VIRTUAL_ENV:-${HOME}/.local/share/bash-scripts}"/bin/postactivate
else
    "${dir}"/bin/bash_scripts_setup "$1"
    workon "$1"
fi

# echo "[ Run legacy initialization scripts ]"
for script in "${dir}"/bash_*.sh ;do
    [[ -x "${script}" ]] && echo "sourcing ${script}" && source "${script}"
done
