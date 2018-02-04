##!/bin/bash -x

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

function postinstall_user_ssh_keygen {
  [[ ! -f ~/.ssh/id_rsa ]] && ssh-keygen -t rsa -b 4096
}

function postinstall_user_ssh_config {
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


postinstall_user_ssh_keygen
postinstall_user_ssh_config
postinstall_user_git_config
