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
    fd -I $*
}

function ffdir {
    fd -I -t d *$
}

function ffscala {
    fd -I -e scala $*
}

function ffdhall {
    fd -I -e dhall $*
}

function  ffjava {
    fd -I -e java $*
}

function   ffsbt {
    fd -I -e sbt $*
}

function   ffxml {
    fd -I -e xml $*
}

function   ffant {
    fd -I -e ant $*
}

function   ffpom {
    fd -I -e pom $*
}

function   fftxt {
    fd -I -e txt $*
}

function    ffel {
    fd -I -e el $*
}

function    ffrs {
    fd -I -e rs $*
}

function    ffpy {
    fd -I -e py $*
}

function    ffsh {
    fd -I -e sh $*
}

function    ffmd {
    fd -I -e md $*
}

function   ffrst {
    fd -I -e rst $*
}

function    ffts {
    fd -I -e ts $*
}

function    ffjs {
    fd -I -e js $*
}

function  ffjson {
    fd -I -e json $*
}

function   ffcss {
    fd -I -e css $*
}

function  ffform {
    fd -I -e form $*
}

function  ffconf {
    fd -I -e cfg -e conf -e config -e ini $*
}

function   ffyaml {
    fd -I -e yml -e yaml $*
}

function  fftoml {
    fd -I -e toml $*
}

function   ffcpp {
    fd -I -e c -e h -e cpp -e hpp $*
}

function   ffsql {
    fd -I -e sql $*
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
