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
alias du='du -sh'

# the obligatory Emacs
VISUAL=emacs
EDITOR=emacs
ALTERNATE_EDITOR=
export VISUAL EDITOR ALTERNATE_EDITOR
alias e='emacs -nw'

# some simple helpers
alias upper='tr [:lower:] [:upper:]'
alias lower='tr [:upper:] [:lower:]'

# viewing files nicely
export LESS=' -R '
export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'
export LESSCLOSE='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s %s'
export VIEWER=less

# viewing file differences
alias cdiff='diff -Naur'
alias sdiff='diff -Npry'
alias kdiff='kdiff3'
alias vdiff='/opt/developer/idea/bin/idea.sh diff'


## finding contents in files easily

alias sources='fgrep -v /target/ | fgrep -v /target_sbt/ | fgrep -v /.hg/ | fgrep -v /.git/ | fgrep -v /.idea/'

alias  fffile='find . -type f | sources'
alias   ffdir='find . -type d | sources'
alias ffscala='find . -type f -name "*.scala"   | sources'
alias  ffjava='find . -type f -name "*.java"    | sources'
alias   ffsbt='find . -type f -name "*.sbt"     | sources'
alias   ffxml='find . -type f -name "*.xml"     | sources'
alias   ffant='find . -type f -name "build.xml" | sources'
alias   ffpom='find . -type f -name "pom.xml"   | sources'
alias    ffrs='find . -type f -name "*.rs"      | sources'
alias    ffpy='find . -type f -name "*.py"      | sources'
alias    ffsh='find . -type f -name "*.sh"      | sources'
alias    ffjs='find . -type f -name "*.js"      | sources'
alias   ffcss='find . -type f -name "*.css"     | sources'
alias  ffform='find . -type f -name "*.form"    | sources'
alias  ffconf='find . -type f -name "*.conf"    | sources'
alias   ffcpp='find . -type f \( -name "*.cpp" -o -name "*.hpp" \)   | sources'
alias     ffc='find . -type f \( -name "*.c"   -o -name "*.h"   \)   | sources'


    
alias  fgfile='fffile  | xargs fgrep --color -H -n '
alias   fgdir='ffdir   | xargs fgrep --color -H -n '
alias fgscala='ffscala | xargs fgrep --color -H -n '
alias  fgjava='ffjava  | xargs fgrep --color -H -n '
alias   fgsbt='ffsbt   | xargs fgrep --color -H -n '
alias   fgxml='ffxml   | xargs fgrep --color -H -n '
alias   fgpom='ffant   | xargs fgrep --color -H -n '
alias   fgpom='ffpom   | xargs fgrep --color -H -n '
alias    fgrs='ffrs    | xargs fgrep --color -H -n '
alias    fgpy='ffpy    | xargs fgrep --color -H -n '
alias    fgsh='ffsh    | xargs fgrep --color -H -n '
alias    fgjs='ffjs    | xargs fgrep --color -H -n '
alias   fgcss='ffcss   | xargs fgrep --color -H -n '
alias  fgform='ffform  | xargs fgrep --color -H -n '
alias  fgconf='ffconf  | xargs fgrep --color -H -n '
alias   fgcpp='ffcpp   | xargs fgrep --color -H -n '
alias     fgc='ffc     | xargs fgrep --color -H -n '
