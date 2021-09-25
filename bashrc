#!/bin/bash -eu

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[ -z "$PS1" ] && return


function __bash_path_prepend() {
  [[ ! -z "$1" ]] && echo "$PATH" | tr ':' '\n' | fgrep "$1" > /dev/null || export PATH="$1:${PATH}"
}
function __bash_path_append() {
  [[ ! -z "$1" ]] && echo "$PATH" | tr ':' '\n' | fgrep "$1" > /dev/null || export PATH="${PATH}:$1"
}

function __bash_source_highlight {
  apt+ install lsb_release
  case "$(lsb_release -is)" in
    Debian|Ubuntu)
        export LESS=' -R ';
        export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s';
        export LESSCLOSE='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s %s';
        export VIEWER=less;
        ;;
    *)
        export LESS=' -R ';
        export LESSOPEN='| /usr/bin/src-hilite-lesspipe.sh %s';
        export LESSCLOSE='| /usr/bin/src-hilite-lesspipe.sh %s %s';
        export VIEWER=less;
        ;;
  esac
}

function __bash_install_pip3 {
    local v=$(python3 -V | cut -d' ' -f2 | cut -d. -f1-2 | tr -d [.])
    apt+ install python${v}-pip
}

function mkvirtualenv {
  if [ ! -z "$1" ] ;then
    [[ -d "${HOME}/.virtualenvs" ]] || mkdir -p "${HOME}/.virtualenvs"
    which pip3 >/dev/null | __bash_install_pip3
    pip3 install python3-venv
    python3 -m venv "${HOME}/.virtualenvs/${1}"
  fi
}

function workon {
    if [ ! -z "${1}" ] ;then
    source "${HOME}/.virtualenvs/${1}/bin/activate"
    for script in ${VIRTUAL_ENV:-${HOME}/.local/share/bash-scripts}/postactivate/head.d/*.sh \
                  ${VIRTUAL_ENV:-${HOME}/.local/share/bash-scripts}/postactivate/postactivate.d/*.sh \
                  ${VIRTUAL_ENV:-${HOME}/.local/share/bash-scripts}/postactivate/tail.d/*.sh ;do
      [[ -x "${script}" ]] && echo "sourcing ${script}" && source "${script}"
    done
  fi
}

function __workon_complete {
  local cur prev opts base
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts=""

  local envs=$( ls -p ~/.virtualenvs | fgrep / | sed 's:/::' )
  COMPREPLY=( $(compgen -W "${envs}" -- ${cur}) )
  return 0
}

complete -F __workon_complete workon


dir=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
__bash_path_prepend "${dir}/bin"
__bash_path_prepend "${HOME}/.local/bin"


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

##FIXME: the obligatory Emacs (or a surrogate...)
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

# viewing files nicely
__bash_source_highlight

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
export SOFTWARE="${SOFTWARE:=$HOME/Downloads}"
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
export PROMPT_COMMAND='printf "%+7s %s\n" ${$} "$(history 1)" >> "${HOME}/.bash_history+/$(date +%Y%m%d)"'
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s cmdhist


# Create directory structure
for folder in "${HOME}"/.local/share/bash-scripts/postactivate/{head.d,postactivate.d,tail.d} ;do
    [[ ! -d "${folder}" ]] && mkdir -p "${folder}"
done

# echo "[ Run user defined initialization scripts ]"
for script in "${HOME}"/bin/bash_*.sh ;do
    [[ -x "${script}" ]] && echo "sourcing ${script}" && source "${script}"
done
