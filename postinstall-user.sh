#!/bin/bash


function postinstall_user_ssh_make_config {
cat <<EOD
Host github.com
    HostName github.com
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_rsa_github_%l

Host bitbucket.org
    HostName bitbucket.org
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_rsa_bitbucket_%l
EOD
}

function postinstall_user_ssh_config {
  [[ ! -d ~/.ssh ]] && mkdir -p ~/.ssh && chmod 700 ~/.ssh
  [[ ! -f ~/.ssh/config ]] && postinstall_user_ssh_make_config >> ~/.ssh/config
}

function postinstall_user_git_make_config {
local user=$1
local email=$2
cat <<EOD
[user]
  user  = ${user}
  email = ${email}

[alias]
  pullall  = !"git fetch origin -v && git pull && git fetch upstream -v" 
  fetch-force = !"git fetch && git reset --hard FETCH_HEAD && git clean -df"
  incoming = !"git fetch && git log ..origin/master"
  unstage = reset HEAD
  pre-merge = merge --no-commit --no-ff
  del-branch = push origin --delete

[diff]
  tool = "intellij"

[difftool "intellij"]
  cmd = $HOME/tools/idea/bin/idea.sh diff \"$LOCAL\" \"$REMOTE\"               

[merge]
  tool = "intellij"
  conflictstyle = diff3

[mergetool]
  prompt = false

[mergetool "intellij"]
  cmd = $HOME/tools/idea/bin/idea.sh merge \"$LOCAL\" \"$BASE\" \"$REMOTE\" \"$MERGED\"  

[push]
  default = simple
EOD
}

function postinstall_user_git_config {
  if [ ! -f ~/.gitconfig ] ;then
    local user=$(getent passwd $USER | cut -d: -f5 | cut -d, -f1)
    local email=$(getent passwd $USER | cut -d: -f5 | cut -d, -f2)
    local email=${email:=$USER@$(dnsdomainname)}
    postinstall_user_git_make_config "$user" "$email" >> ~/.gitconfig
  fi
}

function postinstall_user_download_bash_scripts {
  [[ ! -d $HOME/workspace ]] && mkdir -p $HOME/workspace
  pushd $HOME/workspace
  if [ ! -d bash-scripts ] ;then
    git clone http://github.com/frgomes/bash-scripts
  else
    cd bash-scripts
    git pull
  fi
  popd
  [[ ! -e $HOME/scripts ]] && ln -s $HOME/workspace/bash-scripts $HOME/scripts
}

function postinstall_user_download_carpalx {
  [[ ! -d $HOME/workspace ]] && mkdir -p $HOME/workspace
  pushd $HOME/workspace
  if [ ! -d carpalx ] ;then
    git clone http://github.com/frgomes/carpalx
  else
    cd carpalx
    git pull
  fi
  popd
}

function postinstall_user_download_dot_emacsd {
  pushd $HOME
  if [ ! -d .emacs.d ] ;then
    git clone http://github.com/frgomes/.emacs.d
  else
    cd .emacs.d
    git pull
  fi
  popd
}

function postinstall_user_virtualenvs {
  source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
  for v in 3 ;do
    for name in j8s11 j8s12 ;do
      if [[ ! -d ~/.virtualenvs/p${v}${name} ]] ;then
        mkvirtualenv -p /usr/bin/python${v} p${v}${name}
        pip${v} install --upgrade pip
        pip${v} install --upgrade pylint pyflakes
      fi
    done
  done
}

function postinstall_user_firefox {
  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  local app=firefox
  local lang=$(echo $LANG | cut -d. -f1 | sed "s/_/-/")
  local hwarch=$(uname -m)
  local osarch=$(uname -s | tr [:upper:] [:lower:])
  local version=65.0

  if [ ! -e ~/Downloads/${app}-${version}.tar.bz2 ] ;then
    pushd ~/Downloads 2>&1 > /dev/null
    wget https://ftp.mozilla.org/pub/${app}/releases/${version}/${osarch}-${hwarch}/${lang}/${app}-${version}.tar.bz2
    popd 2>&1 > /dev/null
  fi

  local tools=${TOOLS_HOME:=$HOME/tools}
  [[ ! -d ${tools}        ]] && mkdir -p ${tools}

  pushd ${tools} 2>&1 > /dev/null
  tar xpf ~/Downloads/${app}-${version}.tar.bz2
  popd 2>&1 > /dev/null

  [[ ! -d ~/bin ]] && mkdir -p ~/bin
  ln -s ${tools}/${app}/${app} ~/bin/${app}
  echo ~/bin/${app}
}

function postinstall_user_thunderbird {
  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  local app=thunderbird
  local lang=$(echo $LANG | cut -d. -f1 | sed "s/_/-/")
  local hwarch=$(uname -m)
  local osarch=$(uname -s | tr [:upper:] [:lower:])
  local version=60.5.0
  if [ ! -e ~/Downloads/${app}-${version}.tar.bz2 ] ;then
    pushd ~/Downloads 2>&1 > /dev/null
    wget https://ftp.mozilla.org/pub/${app}/releases/${version}/${osarch}-${hwarch}/${lang}/${app}-${version}.tar.bz2
    popd 2>&1 > /dev/null
  fi

  local tools=${TOOLS_HOME:=$HOME/tools}
  [[ ! -d ${tools}        ]] && mkdir -p ${tools}

  pushd ${tools} 2>&1 > /dev/null
  tar xpf ~/Downloads/${app}-${version}.tar.bz2
  popd 2>&1 > /dev/null

  [[ ! -d ~/bin ]] && mkdir -p ~/bin
  ln -s ${tools}/${app}/${app} ~/bin/${app}
  echo ~/bin/${app}
}

function postinstall_user {
  postinstall_user_firefox
  postinstall_user_thunderbird

  postinstall_user_ssh_config
  postinstall_user_git_config

  postinstall_user_download_bash_scripts
  postinstall_user_download_carpalx
  postinstall_user_download_dot_emacsd

  postinstall_user_virtualenvs
}


postinstall_user
