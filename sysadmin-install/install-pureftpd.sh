#!/bin/bash -eu

# Compiled from
#  https://www.vultr.com/docs/setup-pure-ftpd-with-tls-on-debian-9

function install_pureftpd_binaries {
  apt+ install pure-ftpd-common pure-ftpd
}

function install_pureftpd_config {
  [[ ! -d /etc/pure-ftpd/conf ]] && sudo mkdir -p /etc/pure-ftpd/conf
  [[ ! -d /etc/pure-ftpd/auth ]] && sudo mkdir -p /etc/pure-ftpd/auth

  # Enable Pure-FTPd's database and disable PAM and Unix authentication to enable virtual users:
  sudo ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/auth/50pure
  echo no | sudo tee /etc/pure-ftpd/conf/PAMAuthentication
  echo no | sudo tee /etc/pure-ftpd/conf/UnixAuthentication

  # Set Pure-FTPd to create home directories for users at their first login:
  echo "yes" | sudo tee /etc/pure-ftpd/conf/CreateHomeDir

  # Chroot everyone.
  echo "yes" | sudo tee /etc/pure-ftpd/conf/ChrootEveryone
}

function install_pureftpd_virtual_users {
  getent passwd | \
    awk -F: '{ if ( $4 >= 1000 && $4 < 10000 ) print $1 }' | \
        while read user ;do
          sudo mkdir -p /home/${user}/pure-ftpd
          sudo chown ${user}:${user} /home/${user}/pure-ftpd
          echo "[ Enter pure-ftpd password for ${user} ]"
          sudo pure-pw useradd ${user} -u ${user} -g ${user} -d /home/${user}/pure-ftpd
        done
  sudo pure-pw mkdb
}


function install_pureftpd {
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd $*
  done
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(grep -E "^function " $self | cut -d' ' -f2 | tail -1)
  $cmd $*
fi
