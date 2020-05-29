#!/bin/bash


 ##
## utilities for simple text transformations
##
function upper {
    tr [:lower:] [:upper:] $*
}

function lower {
    tr [:upper:] [:lower:] $*
}

function trim {
    tr -d [:blank:] $*
}

function capitalize {
    sed -E 's/[^ \t]*/\u&/g' $*
}

function camelCase {
    sed -E 's/[^ \t]*/\u&/g' | sed -E 's/[ \t]*//g' | sed -E 's/[^ \t]*/\l&/g' $*
}

function chopLeft {
    local -i n=${1}
    local -i n=${n:=0}
    while read line ;do
      echo ${line:${n}}
    done
}

function chopRight {
    local -i n=${1}
    local -i n=${n:=0}
    while read line ;do
      echo ${line::${#line}-${n}}
    done
}

function mkString {
    local sep=${1}
    local sep=${sep:=,}
    paste -sd${sep}
}

 ##
## viewing file differences
##
function cdiff {
    diff -Naur $*
}
function sdiff {
    diff -Npry $*
}
function kdiff {
    kdiff3 $*
}
function vdiff {
    diffuse $*
}


 ##
## finding contents in files easily
##

function  fffile {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -print0
}

function ffscala {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.scala' -print0
}

function ffdhall {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.dhall' -print0
}

function  ffjava {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.java' -print0
}

function   ffsbt {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.sbt' -print0
}

function   ffxml {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.xml' -print0
}

function   ffant {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.ant' -print0
}

function   ffpom {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name 'pom.xml' -print0
}

function   fftxt {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.txt' -print0
}

function    ffel {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.el' -print0
}

function    ffrs {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.rs' -print0
}

function    ffpy {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.py' -print0
}

function    ffsh {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.sh' -print0
}

function    ffmd {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.md' -print0
}

function   ffrst {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.rst' -print0
}

function    ffts {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' -o -path '.**/node_modules' -o '.**/typings' \) -prune -o -name '*.ts' -print0
}

function    ffjs {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' -o -path '.**/node_modules' -o '.**/typings' \) -prune -o -name '*.js' -print0
}

function  ffjson {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' -o -path '.**/node_modules' -o '.**/typings' \) -prune -o -name '*.json' -print0
}

function   ffcss {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.css' -print0
}

function  ffform {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.form' -print0
}

function  ffconf {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.conf' -print0
}

function   ffyml {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o \( -name '*.yml' -o -name '*.yaml' \)  -print0
}

function  ffyaml {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o \( -name '*.yml' -o -name '*.yaml' \)  -print0
}

function  fftoml {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.toml' -print0
}

function  ffprop {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.properties' -print0
}

function  ffdesc {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.descriptor' -print0
}

function  ffprof {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.profile' -print0
}

function   ffcpp {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o \( -name '*.c' -o -name '*.h' -o -name '*.cpp' -o -name '*.hpp' \)  -print0
}

function   ffsql {
    find . \( -path '.**/.git' -o -path '.**/.hg' -o -path '.**/.idea' \) -prune -o -name '*.sql' -print0
}

function  fgfile {
    fffile  | xargs -0 grep -H -n  $*
}

function   fgdir {
    ffdir   | xargs -0 grep -H -n  $*
}

function fgscala {
    ffscala | xargs -0 grep -H -n  $*
}

function fgdhall {
    ffdhall | xargs -0 grep -H -n  $*
}

function  fgjava {
    ffjava  | xargs -0 grep -H -n  $*
}

function   fgsbt {
    ffsbt   | xargs -0 grep -H -n  $*
}

function   fgxml {
    ffxml   | xargs -0 grep -H -n  $*
}

function   fgpom {
    ffant   | xargs -0 grep -H -n  $*
}

function   fgpom {
    ffpom   | xargs -0 grep -H -n  $*
}

function   fgtxt {
    fftxt   | xargs -0 grep -H -n  $*
}

function    fgel {
    ffel    | xargs -0 grep -H -n  $*
}

function    fgrs {
    ffrs    | xargs -0 grep -H -n  $*
}

function    fgpy {
    ffpy    | xargs -0 grep -H -n  $*
}

function    fgsh {
    ffsh    | xargs -0 grep -H -n  $*
}

function    fgmd {
    ffmd    | xargs -0 grep -H -n  $*
}

function   fgrst {
    ffrst   | xargs -0 grep -H -n  $*
}

function    fgts {
    ffts    | xargs -0 grep -H -n  $*
}

function    fgjs {
    ffjs    | xargs -0 grep -H -n  $*
}

function  fgjson {
    ffjson  | xargs -0 grep -H -n  $*
}

function   fgcss {
    ffcss   | xargs -0 grep -H -n  $*
}

function  fgform {
    ffform  | xargs -0 grep -H -n  $*
}

function  fgconf {
    ffconf  | xargs -0 grep -H -n  $*
}

function   fgyml {
    ffyml   | xargs -0 grep -H -n  $*
}

function  fgyaml {
    ffyaml  | xargs -0 grep -H -n  $*
}

function  fgtoml {
    fftoml  | xargs -0 grep -H -n  $*
}

function  fgprop {
    ffprop  | xargs -0 grep -H -n  $*
}

function  fgdesc {
    ffdesc  | xargs -0 grep -H -n  $*
}

function  fgprof {
    ffprof  | xargs -0 grep -H -n  $*
}

function   fgcpp {
    ffcpp   | xargs -0 grep -H -n  $*
}

function   fgsql {
    ffsql   | xargs -0 grep -H -n  $*
}


 ##
## network utilities
##
function listening {
    netstat -an | fgrep LISTEN | fgrep -v LISTENING
}

function ips {
    ip -o addr show | fgrep "scope global" | sed -r "s/[ \t]+/ /g" | cut -d" " -f2,3,4
}


 ##
## copy/paste using the clipboard
##
function ctrlc {
    xclip -i -selection clipboard
}

function ctrlv {
    xclip -o -selection clipboard
}


 ##
## utilities for restarting PlasmaShell
##
function plasma_start {
    kstart plasmashell
}

function plasma_stop {
    killall plasmashell
}

function plasma_restart {
    killall plasmashell; kstart plasmashell
}
