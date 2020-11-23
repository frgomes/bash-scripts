#!/bin/bash

##
 # Lists all repositories of an organization in Github.
 # BEWARE of ampersands!!! If your URL contain ampersands, make sure bash does not interpret it!!!
 ##
function github_org_repositories {
  local org=${1:-}
  local token=${2:-}
  local tmp=/tmp/bash_25github_org_repositories_$$

  if [ -z "$token" ] ;then
    auth=""
  else
    auth="-u ${token}:x-oauth-basic"
  fi

  local n=1
  while true ;do
    [[ -f $tmp ]] && rm $tmp
    ## curl -vs -u ${token}:x-oauth-basic https://api.github.com/orgs/${org}/repos?page=${n} 2>/dev/null | \
    curl -vs ${auth} https://api.github.com/orgs/${org}/repos?page=${n} 2>/dev/null | \
      fgrep ssh_url | \
        sed -r 's/[ \t]+//g' | cut -d':' -f2- | tr -d '",' > $tmp
    [[ ! -s $tmp ]] && break
    cat ${tmp}
    (( n++ ))
  done \
    | sort \
      | uniq
    
}


##
 # Lists all repositories of an organization in Github.
 # BEWARE of ampersands!!! If your URL contain ampersands, make sure bash does not interpret it!!!
 ##
function github_user_repositories {
  local user=${1:-}
  local token=${2:-}
  local tmp=/tmp/bash_25github_user_repositories_$$

  if [ -z "$token" ] ;then
    auth=""
  else
    auth="-u ${token}:x-oauth-basic"
  fi

  local n=1
  while true ;do
    [[ -f $tmp ]] && rm $tmp
    ## curl -vs -u ${token}:x-oauth-basic https://api.github.com/orgs/${org}/repos?page=${n} 2>/dev/null | \
    curl -vs ${auth} https://api.github.com/users/${user}/repos?page=${n} 2>/dev/null | \
      fgrep ssh_url | \
        sed -r 's/[ \t]+//g' | cut -d':' -f2- | tr -d '",' > $tmp
    [[ ! -s $tmp ]] && break
    cat ${tmp}
    (( n++ ))
  done \
    | sort \
      | uniq
    
}
