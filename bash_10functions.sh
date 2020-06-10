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
## utilities for JSON and YAML processing
##

function yaml_validate {
  python -c 'import sys, yaml, json; yaml.safe_load(sys.stdin.read())'
}

function yaml2json {
  python -c 'import sys, yaml, json; print(json.dumps(yaml.safe_load(sys.stdin.read())))'
}

function yaml2json_pretty {
  python -c 'import sys, yaml, json; print(json.dumps(yaml.safe_load(sys.stdin.read()), indent=2, sort_keys=False))'
}

function json_validate {
  python -c 'import sys, yaml, json; json.loads(sys.stdin.read())'
}

function json2yaml {
  python -c 'import sys, yaml, json; print(yaml.dump(json.loads(sys.stdin.read()), sort_keys=False))'
}

function yaml_split {
  for file in "$@" ;do
    local dir=$(dirname "${file}")
    local name=$(basename "${file}" .yaml)
    csplit --quiet --prefix="${dir}/${name}" --suffix-format='.%03d.yaml.part' --elide-empty-files "${file}" /---/ "{*}"
    for f in "${dir}/${name}".*.yaml.part ; do
        local kind=$(cat $f | yaml2json | jq .kind | sed 's/"//g')
        local count=$(basename "$f" | cut -d. -f 2)
        local fname=${name}.${count}.${kind}.yaml
        ## echo "${f} -> ${fname}"
        tail +2 $f > "${dir}/${fname}"
        rm $f
    done
  done
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
## finding files easily
##

function fffile {
    fd -I $*
}

function ffdir {
    fd -I -t d $*
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


 ##
## finding contents in files easily
##

function  fgfile {
    rg --no-ignore -H -n $*
}

function fgscala {
    rg --no-ignore -t scala -H -n $*
}

function fgdhall {
    rg --no-ignore -t dhall -H -n $*
}

function  fgjava {
    rg --no-ignore -t java -H -n $*
}

function   fgsbt {
    rg --no-ignore -t sbt -H -n $*
}

function   fgxml {
    rg --no-ignore -t xml -H -n $*
}

function   fgant {
    rg --no-ignore --type-add 'ant:*.ant' -t ant -H -n $*
}

function   fgpom {
    rg --no-ignore --type-add 'pom:*.pom' -t pom -H -n $*
}

function   fgtxt {
    rg --no-ignore -t txt -H -n $*
}

function    fgel {
    rg --no-ignore -t el -H -n $*
}

function    fgrs {
    rg --no-ignore -t rs -H -n $*
}

function    fgpy {
    rg --no-ignore -t py -H -n $*
}

function    fgsh {
    rg --no-ignore -t sh -H -n $*
}

function    fgmd {
    rg --no-ignore -t md -H -n $*
}

function   fgrst {
    rg --no-ignore -t rst -H -n $*
}

function    fgts {
    rg --no-ignore -t ts -H -n $*
}

function    fgjs {
    rg --no-ignore -t js -H -n $*
}

function  fgjson {
    rg --no-ignore -t json -H -n $*
}

function   fgcss {
    rg --no-ignore -t css -H -n $*
}

function  fgconf {
    rg --no-ignore -t config -H -n $*
}

function  fgyaml {
    rg --no-ignore -t yaml -H -n $*
}

function  fgtoml {
    rg --no-ignore -t toml -H -n $*
}

function   fgcpp {
    rg --no-ignore -t cpp -H -n $*
}

function   fgsql {
    rg --no-ignore -t sql -H -n $*
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
