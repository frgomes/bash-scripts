#!/bin/bash

##################################
## Utilities for git and mercurial
##################################


##
## Common to git and mercurial
##


function scm_filter {
  while read line ;do
    s="$( echo $line | cut -d' ' -f 1 )"
    f="$( echo $line | cut -d' ' -f 2 )"
    # echo ":::$s:::$f:::"
    # if [ "$s" == "M" -o "$s" == "A" -o "$s" == "?" ] ;then
    if [ -f "$f" ] ;then
      echo $f
    fi
  done
}


function scm_modified {
  if [ -d .hg ] ;then
    hg status | scm_filter
  elif [ -d .git ] ;then
    git status --porcelain | scm_filter
  fi
}


function scm_changeset {
  here=$( pwd )
  name=$( basename $here )
  dir=~/backup/${SUDO_USER:=${USER}}/changesets${here}

  mkdir -p $dir

  now=$(date +%Y%m%d_%H%M%S )
  file=${dir}/${now}-${name}.tgz

  scm_modified | xargs tar cpzf $file && echo $file
}


function scm_pullall {
  local branch=$1

  for prj in ./ */ ;do
    pushd $prj
    if [ -d .hg ] ;then
      hg pull
      hg checkout branch=${branch:=default}
    elif [ -d .git ] ;then
      git pull
      hg checkout branch=${branch:=master}
    fi
    popd
  done
}




##
## git
##

function git_top_squash {
  local tmp=$(tempfile)
  git log --format=%B -n 1 | head -1 > $tmp
  git reset --soft HEAD~
  git commit --amend -F $tmp
  rm $tmp
}


function git_top_swap {
  git tag top
  git reset --hard HEAD~2
  git cherry-pick top
  git cherry-pick top~1
  git tag -d top
}


function git_tree_squash_all {
  git reset $(git commit-tree HEAD^{tree} -m "Initial import.")
}


function git_remotes {
  if [ $# == 0 ] ;then
    git remote
  else
    echo $* | tr " " "\n"
  fi
}


function git_http_to_ssh {
    local name=${1}
    local name=${name:=origin}
    local url=$( git remote get-url $name )
    [[ "$url" =~ (http[s]?)://(.+)/(.+)/(.+)(\.git)? ]]
    local protocol="${BASH_REMATCH[1]}"
    if [ \( "$protocol" == "http" \) -o \( "$protocol" == "https" \) ] ;then
      local provider="${BASH_REMATCH[2]}"
      local team="${BASH_REMATCH[3]}"
      local prj="${BASH_REMATCH[4]}"
      local ext="${BASH_REMATCH[5]}"
      # workaround https://bitbucket.org/site/master/issues/5154/someone-has-already-registered-that-ssh
      company=$(fgrep Host ~/.ssh/config | fgrep -v Hostname | cut -d' ' -f2)
      if [ X"${company}" != "X" -a X"${provider}" == "Xbitbucket.org" -a -f "~/.ssh/id_rsa_${team}" ] ;then
        provider="${company}"
      fi
      git remote set-url        $name "git@${provider}:${team}/${prj}${ext}"
      git remote set-url --push $name "git@${provider}:${team}/${prj}${ext}"
    fi
}


function git_ssh_to_http {
    local name=${1}
    local name=${name:=origin}
    local url=$( git remote get-url $name )
    [[ "$url" =~ (.+)@(.+):(.+)/(.+)(\.git)? ]]
    local user="${BASH_REMATCH[1]}"
    if [ "$user" == "git" ] ;then
      local provider="${BASH_REMATCH[2]}"
      local team="${BASH_REMATCH[3]}"
      local prj="${BASH_REMATCH[4]}"
      local ext="${BASH_REMATCH[5]}"
      # workaround https://bitbucket.org/site/master/issues/5154/someone-has-already-registered-that-ssh
      company=$(fgrep Host ~/.ssh/config | fgrep -v Hostname | cut -d' ' -f2)
      if [ X"${company}" != "X" -a X"${provider}" == "Xbitbucket.org" -a -f "~/.ssh/id_rsa_${team}" ] ;then
        provider="${company}"
      fi
      git remote set-url        $name "https://${provider}/${team}/${prj}${ext}"
      git remote set-url --push $name "https://${provider}/${team}/${prj}${ext}"
    fi
}


function git_clone {
    module=$1
    url=$2
    echo "[ clone $module ]"
    if [ ! -d $HOME/workspace ] ;then
        mkdir -p $HOME/workspace
    fi
    pushd $HOME/workspace
    if [ ! -d ${module} ] ;then
        pushd $HOME/workspace
        git clone ${url} ${module}
        if [ $? != 0 ] ; then popd; popd; return 1 ;fi
        popd
    else
        pushd $HOME/workspace/${module}
        git pull $url
        if [ $? != 0 ] ; then popd; popd; return 1 ;fi
        popd
    fi
    git status
    popd
}


function git_switch {
    module=$1
    tag=$2
    echo "[ checkout $module ]"
    if [ -d $HOME/workspace/${module} ] ;then
        pushd $HOME/workspace/${module}
	git clean -d -x -f -f
        if [ $? != 0 ] ; then popd; return 1 ;fi
        git checkout tags/${tag} --force
        if [ $? != 0 ] ; then popd; return 1 ;fi
	git submodule update --init --force --recursive
        if [ $? != 0 ] ; then popd; return 1 ;fi
	git clean -d -x -f -f
        if [ $? != 0 ] ; then popd; return 1 ;fi
        git status
        popd
    fi
}
