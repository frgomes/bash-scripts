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

function install_python3_pip {
  which pip3 > /dev/null 2>&1 || (
    case "$(os_release | cut -d: -f1)" in
        Debian|Ubuntu) dpkg-query -s python3-pip > /dev/null 2>&1 || sudo apt install -y python3-pip;;
        openSUSE)
            case "$(os_release | cut -d: -f2)" in
                MicroOS) ;; # does not attempt to mutate the file system
                *) local v="$(python3 -V | cut -d' ' -f2 | cut -d. -f1-2 | tr -d [.])" ;
                   zypper search -i python${v}-pip > /dev/null 2>&1 || sudo zypper install -y python${v}-pip;;
            esac;;
        *) echo "ERROR: Unsupported distribution: ${distro}" ; return 1;;
    esac
  )
}

function mkvirtualenv {
  if [ ! -z "$1" ] ;then
    # make sure python-venv is installed
    case "$(os_release | cut -d: -f1)" in
        Debian|Ubuntu) dpkg-query -s python3-venv > /dev/null 2>&1 || sudo apt install -y python3-venv;;
        openSUSE) ;;
        *) echo "ERROR: Unsupported distribution: ${distro}" ; return 1;;
    esac

    [[ -d "${HOME}/.virtualenvs" ]] || mkdir -p "${HOME}/.virtualenvs"
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


__bash_path_prepend "$(dirname $(readlink -f "${BASH_SOURCE[0]}"))/bin"
__bash_path_prepend "${HOME}/.local/bin"

# make sure python3-pip is installed
install_python3_pip

##FIXME: This is a temporary fix for snaps not being found. Credits: https://www.youtube.com/watch?v=2g-teghxI2A
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

# viewing files nicely
case "$(os_release | cut -d: -f1)" in
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
