#!/bin/bash -x

# Compiled from
#  https://www.vultr.com/docs/setup-pure-ftpd-with-tls-on-debian-9

function install_pureftpd_remove_all {
  sudo service pure-ftpd stop
  sudo apt-get remove --purge  pure-ftpd-common pure-ftpd -y
  sudo rm -r -f /etc/pure-ftpd
}

function install_pureftpd {
  sudo apt-get install pure-ftpd-common pure-ftpd -y
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
  for user in $(getent passwd | awk -F: '{ if ( $4 >= 1000 && $4 < 10000 ) print $1 }') ;do
    sudo mkdir -p /home/${user}/pure-ftpd
    sudo chown ${user}:${user} /home/${user}/pure-ftpd
    echo "[ Enter pure-ftpd password for ${user} ]"
    sudo pure-pw useradd ${user} -u ${user} -g ${user} -d /home/${user}/pure-ftpd
  done
  sudo pure-pw mkdb
}


install_pureftpd_remove_all && install_pureftpd \
  && install_pureftpd_config \
    && install_pureftpd_virtual_users \
      && sudo service pure-ftpd restart
