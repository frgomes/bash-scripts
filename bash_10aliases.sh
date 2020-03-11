#!/bin/bash


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# essential
alias cd='cd -P'
alias la='ls -alL'
alias ll='ls -lhL'
alias lt='ls -lhtL'
alias df='df -h'
alias du='du -h'

# the obligatory Emacs (or its surrogate...)
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

# viewing files nicely
export LESS=' -R '
export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'
export LESSCLOSE='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s %s'
export VIEWER=less

# viewing file differences
alias cdiff='diff -Naur'
alias sdiff='diff -Npry'
alias kdiff='kdiff3'
alias vdiff='${TOOLS_HOME}/idea/bin/idea.sh diff' ##FIXME: sort out dependency of TOOLS_HOME
