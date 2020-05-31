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

function fffile {
    fdfind $*
}

function ffdir {
    fdfind -t d *$
}

function ffscala {
    fdfind -e scala $*
}

function ffdhall {
    fdfind -e dhall $*
}

function  ffjava {
    fdfind -e java $*
}

function   ffsbt {
    fdfind -e sbt $*
}

function   ffxml {
    fdfind -e xml $*
}

function   ffant {
    fdfind -e ant $*
}

function   ffpom {
    fdfind -e pom $*
}

function   fftxt {
    fdfind -e txt $*
}

function    ffel {
    fdfind -e el $*
}

function    ffrs {
    fdfind -e rs $*
}

function    ffpy {
    fdfind -e py $*
}

function    ffsh {
    fdfind -e sh $*
}

function    ffmd {
    fdfind -e md $*
}

function   ffrst {
    fdfind -e rst $*
}

function    ffts {
    fdfind -e ts $*
}

function    ffjs {
    fdfind -e js $*
}

function  ffjson {
    fdfind -e json $*
}

function   ffcss {
    fdfind -e css $*
}

function  ffform {
    fdfind -e form $*
}

function  ffconf {
    fdfind -e cfg -e conf -e config -e ini $*
}

function   ffyaml {
    fdfind -e yml -e yaml $*
}

function  fftoml {
    fdfind -e toml $*
}

function   ffcpp {
    fdfind -e c -e h -e cpp -e hpp $*
}

function   ffsql {
    fdfind -e sql $*
}

function  fgfile {
    rg -H -n $*
}

function fgscala {
    rg -t scala -H -n $*
}

function fgdhall {
    rg -t dhall -H -n  $*
}

function  fgjava {
    rg -t java  -H -n  $*
}

function   fgsbt {
    rg -t sbt   -H -n  $*
}

function   fgxml {
    rg -t xml   -H -n  $*
}

function   fgant {
    rg --type-add 'ant:*.ant' -t ant -H -n  $*
}

function   fgpom {
    rg --type-add 'pom:*.pom' -t pom -H -n  $*
}

function   fgtxt {
    rg -t txt   -H -n  $*
}

function    fgel {
    rg -t el    -H -n  $*
}

function    fgrs {
    rg -t rs    -H -n  $*
}

function    fgpy {
    rg -t py    -H -n  $*
}

function    fgsh {
    rg -t sh    -H -n  $*
}

function    fgmd {
    rg -t md    -H -n  $*
}

function   fgrst {
    rg -t rst   -H -n  $*
}

function    fgts {
    rg -t ts    -H -n  $*
}

function    fgjs {
    rg -t js    -H -n  $*
}

function  fgjson {
    rg -t json  -H -n  $*
}

function   fgcss {
    rg -t css   -H -n  $*
}

function  fgconf {
    rg -t config  -H -n  $*
}

function  fgyaml {
    rg -t yaml  -H -n  $*
}

function  fgtoml {
    rg -t toml  -H -n  $*
}

function   fgcpp {
    rg -t cpp   -H -n  $*
}

function   fgsql {
    rg -t sql   -H -n  $*
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
