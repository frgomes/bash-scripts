#!/bin/bash -x

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

##function postinstall_user_ssh_keygen {
##  [[ ! -f ~/.ssh/id_rsa ]] && ssh-keygen -t rsa -b 4096
##}

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
  pullall  = !"git fetch origin -v && git fetch upstream -v && git merge upstream/master"
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

function postinstall_user_download_debian_bin {
  [[ ! -d $HOME/workspace ]] && mkdir -p $HOME/workspace
  pushd $HOME/workspace
  if [ ! -d debian-bin ] ;then
    git clone http://github.com/frgomes/debian-bin
  else
    cd debian-bin
    git pull
  fi
  popd
  [[ ! -e $HOME/bin ]] && ln -s $HOME/workspace/debian-bin $HOME/bin
}

function postinstall_user_download_debian_scripts {
  [[ ! -d $HOME/workspace ]] && mkdir -p $HOME/workspace
  pushd $HOME/workspace
  if [ ! -d debian-scripts ] ;then
    git clone http://github.com/frgomes/debian-scripts
  else
    cd debian-scripts
    git pull
  fi
  popd
  [[ ! -e $HOME/scripts ]] && ln -s $HOME/workspace/debian-scripts $HOME/scripts
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
  mkvirtualenv -p /usr/bin/python3 j8s11
  mkvirtualenv -p /usr/bin/python3 j8s12
}

## postinstall_user_ssh_keygen
postinstall_user_ssh_config
postinstall_user_git_config

postinstall_user_download_debian_bin
postinstall_user_download_debian_scripts
postinstall_user_download_carpalx
postinstall_user_download_dot_emacsd

postinstall_user_virtualenvs
