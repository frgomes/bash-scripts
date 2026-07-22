#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[ -z "$PS1" ] && return


function __bash_path_prepend() {
  [[ ! -z "${1}" ]] && (echo "${PATH}" | tr ':' '\n' | grep -F "${1}" > /dev/null) || export PATH="${1}:${PATH}"
}
function __bash_path_append() {
  [[ ! -z "${1}" ]] && (echo "${PATH}" | tr ':' '\n' | grep -F "${1}" > /dev/null) || export PATH="${PATH}:${1}"
}

__bash_path_prepend "${HOME}/bin"
__bash_path_append "${HOME}/.local/share/../bin"
__bash_path_append "$(dirname $(readlink -f "${BASH_SOURCE[0]}"))/bin"
__bash_path_append "$(dirname $(readlink -f "${BASH_SOURCE[0]}"))/sbin"

# Choose text editor in this order: emacs, zile, vim, nano, vi
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


function direnv_install {
  if command -v direnv > /dev/null 2>&1; then
    return 0
  else
    export BIN_PATH="${HOME}/.local/bin" 
    [[ -d "${BIN_PATH}" ]] || mkdir -p "${BIN_PATH}"
    curl -sSfL https://direnv.net/install.sh | bash > /dev/null
  fi

  if ! command -v direnv > /dev/null 2>&1; then
    echo "ERROR: could not install direnv" >&2
    return 1
  fi
}
function direnv_hook {
  eval "$(direnv hook bash)"
}
function mise_install {
  ## make sure mise is installed
  which mise > /dev/null 2>&1 || (curl https://mise.run | bash)

  local DIRENV_MISE="${HOME}/.config/direnv/lib/use_mise.sh"
  if [[ ! -f "$DIRENV_MISE" ]] || ! grep -q "use_mise" "$DIRENV_MISE"; then
##-----------------------------------------------------------------------------------
mkdir -p $(dirname "${DIRENV_MISE}")
cat <<EOD >> "$DIRENV_MISE"
# ~/.config/direnv/lib/use_mise.sh
use_mise() {
  export PATH="$HOME/.local/bin:$PATH"

  # 1. Automatically install any tools declared in mise.toml
  "${HOME}/.local/bin/mise" install --quiet >/dev/null 2>&1

  # 2. Export the activated environment to direnv
  direnv_load "${HOME}/.local/bin/mise" direnv exec
}
EOD
##-----------------------------------------------------------------------------------
  fi
}
direnv_install
mise_install
direnv_hook
