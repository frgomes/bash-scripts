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
function sources {
    fgrep -v /.hg/ | fgrep -v /.git/ | fgrep -v /.idea/ $*
}

function  fffile {
    find . -type f                      | sources $*
}

function   ffdir {
    find . -type d                      | sources $*
}

function ffscala {
    find . -type f -name "*.scala"      | sources $*
}

function ffdhall {
    find . -type f -name "*.dhall"      | sources $*
}

function  ffjava {
    find . -type f -name "*.java"       | sources $*
}

function   ffsbt {
    find . -type f -name "*.sbt"        | sources $*
}

function   ffxml {
    find . -type f -name "*.xml"        | sources $*
}

function   ffant {
    find . -type f -name "build.xml"    | sources $*
}

function   ffpom {
    find . -type f -name "pom.xml"      | sources $*
}

function   fftxt {
    find . -type f -name "*.txt"        | sources $*
}

function    ffel {
    find . -type f -name "*.el"         | sources $*
}

function    ffrs {
    find . -type f -name "*.rs"         | sources $*
}

function    ffpy {
    find . -type f -name "*.py"         | sources $*
}

function    ffsh {
    find . -type f -name "*.sh"         | sources $*
}

function    ffmd {
    find . -type f -name "*.md"         | sources $*
}

function   ffrst {
    find . -type f -name "*.rst"        | sources $*
}

function    ffts {
    find . -type f -name "*.ts"         | fgrep -v /node_modules/ | fgrep -v /typings/ | sources $*
}

function    ffjs {
    find . -type f -name "*.js"         | fgrep -v /node_modules/ | fgrep -v /typings/ | sources $*
}

function  ffjson {
    find . -type f -name "*.json"       | fgrep -v /node_modules/ | fgrep -v /typings/ | sources $*
}

function   ffcss {
    find . -type f -name "*.css"        | sources $*
}

function  ffform {
    find . -type f -name "*.form"       | sources $*
}

function  ffconf {
    find . -type f -name "*.conf"       | sources $*
}

function   ffyml {
    find . -type f \( -name "*.yml" -o -name "*.yaml" \) | sources $*
}

function  ffyaml {
    find . -type f \( -name "*.yml" -o -name "*.yaml" \) | sources $*
}

function  fftoml {
    find . -type f -name "*.toml"       | sources $*
}

function  ffprop {
    find . -type f -name "*.properties" | sources $*
}

function  ffdesc {
    find . -type f -name "*.descriptor" | sources $*
}

function  ffprof {
    find . -type f -name "*.profile"    | sources $*
}

function   ffcpp {
    find . -type f \( -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" \)   | sources $*
}

function   ffsql {
    find . -type f -name "*.sql"        | sources $*
}

function  fgfile {
    fffile  | xargs grep -H -n  $*
}

function   fgdir {
    ffdir   | xargs grep -H -n  $*
}

function fgscala {
    ffscala | xargs grep -H -n  $*
}

function fgdhall {
    ffdhall | xargs grep -H -n  $*
}

function  fgjava {
    ffjava  | xargs grep -H -n  $*
}

function   fgsbt {
    ffsbt   | xargs grep -H -n  $*
}

function   fgxml {
    ffxml   | xargs grep -H -n  $*
}

function   fgpom {
    ffant   | xargs grep -H -n  $*
}

function   fgpom {
    ffpom   | xargs grep -H -n  $*
}

function   fgtxt {
    fftxt   | xargs grep -H -n  $*
}

function    fgel {
    ffel    | xargs grep -H -n  $*
}

function    fgrs {
    ffrs    | xargs grep -H -n  $*
}

function    fgpy {
    ffpy    | xargs grep -H -n  $*
}

function    fgsh {
    ffsh    | xargs grep -H -n  $*
}

function    fgmd {
    ffmd    | xargs grep -H -n  $*
}

function   fgrst {
    ffrst   | xargs grep -H -n  $*
}

function    fgts {
    ffts    | xargs grep -H -n  $*
}

function    fgjs {
    ffjs    | xargs grep -H -n  $*
}

function  fgjson {
    ffjson  | xargs grep -H -n  $*
}

function   fgcss {
    ffcss   | xargs grep -H -n  $*
}

function  fgform {
    ffform  | xargs grep -H -n  $*
}

function  fgconf {
    ffconf  | xargs grep -H -n  $*
}

function   fgyml {
    ffyml   | xargs grep -H -n  $*
}

function  fgyaml {
    ffyaml  | xargs grep -H -n  $*
}

function  fgtoml {
    fftoml  | xargs grep -H -n  $*
}

function  fgprop {
    ffprop  | xargs grep -H -n  $*
}

function  fgdesc {
    ffdesc  | xargs grep -H -n  $*
}

function  fgprof {
    ffprof  | xargs grep -H -n  $*
}

function   fgcpp {
    ffcpp   | xargs grep -H -n  $*
}

function   fgsql {
    ffsql   | xargs grep -H -n  $*
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
