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

# the obligatory Emacs
VISUAL=emacs
EDITOR=emacs
ALTERNATE_EDITOR=
export VISUAL EDITOR ALTERNATE_EDITOR
alias e='emacs -nw'

# some simple helpers
alias upper='tr [:lower:] [:upper:]'
alias lower='tr [:upper:] [:lower:]'
alias ips='ip -o addr show | fgrep "scope global" | sed -r "s/[ \t]+/ /g" | cut -d" " -f2,3,4'

# viewing files nicely
export LESS=' -R '
export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'
export LESSCLOSE='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s %s'
export VIEWER=less

# viewing file differences
alias cdiff='diff -Naur'
alias sdiff='diff -Npry'
alias kdiff='kdiff3'
alias vdiff='${TOOLS_HOME}/idea/bin/idea.sh diff'

# network utilities
alias listening='netstat -an | fgrep LISTEN | fgrep -v LISTENING'

# docker utilities
alias docker_run_beakerx='docker run -p 8888:8888 beakerx/beakerx $*'
alias docker_run_postgres='docker run -d --rm -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=postgres postgres:11.3-alpine -c shared_buffers=500MB -c fsync=off'

# copy/paste using the clipboard
alias ctrlc='xclip -i -selection clipboard'
alias ctrlv='xclip -o -selection clipboard'

## finding contents in files easily

alias sources='fgrep -v /target/ | fgrep -v /.hg/ | fgrep -v /.git/ | fgrep -v /.idea/'

alias  fffile='find . -type f                      | sources'
alias   ffdir='find . -type d                      | sources'
alias ffscala='find . -type f -name "*.scala"      | sources'
alias  ffjava='find . -type f -name "*.java"       | sources'
alias   ffsbt='find . -type f -name "*.sbt"        | sources'
alias   ffxml='find . -type f -name "*.xml"        | sources'
alias   ffant='find . -type f -name "build.xml"    | sources'
alias   ffpom='find . -type f -name "pom.xml"      | sources'
alias   fftxt='find . -type f -name "*.txt"        | sources'
alias    ffel='find . -type f -name "*.el"         | sources'
alias    ffrs='find . -type f -name "*.rs"         | sources'
alias    ffpy='find . -type f -name "*.py"         | sources'
alias    ffsh='find . -type f -name "*.sh"         | sources'
alias    ffmd='find . -type f -name "*.md"         | sources'
alias   ffrst='find . -type f -name "*.rst"        | sources'
alias    ffts='find . -type f -name "*.ts"         | fgrep -v /node_modules/ | fgrep -v /typings/ | sources'
alias    ffjs='find . -type f -name "*.js"         | fgrep -v /node_modules/ | fgrep -v /typings/ | sources'
alias  ffjson='find . -type f -name "*.json"       | fgrep -v /node_modules/ | fgrep -v /typings/ | sources'
alias   ffcss='find . -type f -name "*.css"        | sources'
alias  ffform='find . -type f -name "*.form"       | sources'
alias  ffconf='find . -type f -name "*.conf"       | sources'
alias   ffyml='find . -type f \( -name "*.yml" -o -name "*.yaml" \) | sources'
alias  ffyaml='find . -type f \( -name "*.yml" -o -name "*.yaml" \) | sources'
alias  fftoml='find . -type f -name "*.toml"       | sources'
alias  ffprop='find . -type f -name "*.properties" | sources'
alias  ffdesc='find . -type f -name "*.descriptor" | sources'
alias  ffprof='find . -type f -name "*.profile"    | sources'
alias   ffcpp='find . -type f \( -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" \)   | sources'
alias   ffsql='find . -type f -name "*.sql"        | sources'

alias  fgfile='fffile  | xargs grep -H -n '
alias   fgdir='ffdir   | xargs grep -H -n '
alias fgscala='ffscala | xargs grep -H -n '
alias  fgjava='ffjava  | xargs grep -H -n '
alias   fgsbt='ffsbt   | xargs grep -H -n '
alias   fgxml='ffxml   | xargs grep -H -n '
alias   fgpom='ffant   | xargs grep -H -n '
alias   fgpom='ffpom   | xargs grep -H -n '
alias   fgtxt='fftxt   | xargs grep -H -n '
alias    fgel='ffel    | xargs grep -H -n '
alias    fgrs='ffrs    | xargs grep -H -n '
alias    fgpy='ffpy    | xargs grep -H -n '
alias    fgsh='ffsh    | xargs grep -H -n '
alias    fgmd='ffmd    | xargs grep -H -n '
alias   fgrst='ffrst   | xargs grep -H -n '
alias    fgts='ffts    | xargs grep -H -n '
alias    fgjs='ffjs    | xargs grep -H -n '
alias  fgjson='ffjson  | xargs grep -H -n '
alias   fgcss='ffcss   | xargs grep -H -n '
alias  fgform='ffform  | xargs grep -H -n '
alias  fgconf='ffconf  | xargs grep -H -n '
alias   fgyml='ffyml   | xargs grep -H -n '
alias  fgyaml='ffyaml  | xargs grep -H -n '
alias  fgtoml='fftoml  | xargs grep -H -n '
alias  fgprop='ffprop  | xargs grep -H -n '
alias  fgdesc='ffdesc  | xargs grep -H -n '
alias  fgprof='ffprof  | xargs grep -H -n '
alias   fgcpp='ffcpp   | xargs grep -H -n '
alias   fgsql='ffsql   | xargs grep -H -n '
