#!/bin/bash -x

apt-get update -y
apt-get dist-upgrade -y
apt-get autoremove --purge -y

apt-get install sudo -y


##------------------------------------------


function postinstall_remove_if_installed {
  dpkg-query -W $* | while read pkg ;do sudo apt-get remove --purge -y $pkg ;done
}


##------------------------------------------


function postinstall_compression {
  sudo apt-get install tar bsdtar bzip2 pbzip2 lbzip2 zstd lzip plzip xz-utils pxz pigz zip unzip p7zip p7zip-rar -y

  #TODO: needs code review and tests!!!
  #[[ ! -e /usr/local/bin/bzip2   ]] && sudo ln -s /usr/bin/lbzip2   /usr/local/bin/bzip2
  #[[ ! -e /usr/local/bin/bunzip2 ]] && sudo ln -s /usr/bin/lbunzip2 /usr/local/bin/bunzip2
  #[[ ! -e /usr/local/bin/bzcat   ]] && sudo ln -s /usr/bin/lbzcat   /usr/local/bin/bzcat
  #[[ ! -e /usr/local/bin/gzip    ]] && sudo ln -s /usr/bin/pigz     /usr/local/bin/gzip
  #[[ ! -e /usr/local/bin/gunzip  ]] && sudo ln -s /usr/bin/unpigz   /usr/local/bin/gunzip
  #[[ ! -e /usr/local/bin/lzip    ]] && sudo ln -s /usr/bin/plzip    /usr/local/bin/lzip
  #[[ ! -e /usr/local/bin/xz      ]] && sudo ln -s /usr/bin/pxz      /usr/local/bin/xz
}

function postinstall_scm {
  sudo apt-get install git mercurial -y
}

function postinstall_downloads {
  sudo apt-get install wget curl -y
}

function postinstall_editors {
  sudo apt-get install zile vim -y
}

function postinstall_apt {
  sudo apt-get install apt-file apt-transport-https apt-utils -y
  sudo apt-file update
}

function postinstall_security_hardening {
  sudo apt-get install lsb-release -y
  sudo apt-get install fail2ban -y
  sudo apt-get install policycoreutils haveged network-manager-openvpn -y
  sudo restorecon -R -v ~/.cert
  # See: https://www.cyberciti.biz/faq/howto-check-linux-rootkist-with-detectors-software/
  sudo apt-get install chkrootkit rkhunter scanssh -y
}

function postinstall_networking {
  sudo apt-get install dnsutils nmap -y
}

function postinstall_virtualenv {
  sudo apt-get install virtualenvwrapper -y
  source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
}

function postinstall_source_code_utils {
  sudo apt-get install less source-highlight -y
}

function postinstall_firefox {
  [[ ! -d /root/Downloads ]] && sudo mkdir -p /root/Downloads
  local app=firefox
  local lang=$(echo $LANG | cut -d. -f1 | sed "s/_/-/")
  local hwarch=$(uname -m)
  local osarch=$(uname -s | tr [:upper:] [:lower:])
  local version=58.0

  if [ ! -e /root/Downloads/${app}-${version}.tar.bz2 ] ;then
    pushd /root/Downloads 2>&1 > /dev/null
    wget https://ftp.mozilla.org/pub/${app}/releases/${version}/${osarch}-${hwarch}/${lang}/${app}-${version}.tar.bz2
    popd 2>&1 > /dev/null
  fi

  if [ ! -d /opt/${app} ] ;then
    [[ ! -d /opt ]] && mkdir -p /opt
    pushd /opt 2>&1 > /dev/null
    tar xpf /root/Downloads/${app}-${version}.tar.bz2
    popd 2>&1 > /dev/null
  fi
  if [ -L /usr/local/bin/${app} ] ;then
    sudo rm /usr/local/bin/${app}
  fi

  sudo ln -s /opt/${app}/${app} /usr/local/bin/${app}
  echo /usr/local/bin/${app}

  postinstall_remove_if_installed firefox-esr
}

function postinstall_thunderbird {
  [[ ! -d /root/Downloads ]] && sudo mkdir -p /root/Downloads
  local app=thunderbird
  local lang=$(echo $LANG | cut -d. -f1 | sed "s/_/-/")
  local hwarch=$(uname -m)
  local osarch=$(uname -s | tr [:upper:] [:lower:])
  local version=58.0b3

  if [ ! -e /root/Downloads/${app}-${version}.tar.bz2 ] ;then
    pushd /root/Downloads 2>&1 > /dev/null
    wget https://ftp.mozilla.org/pub/${app}/releases/${version}/${osarch}-${hwarch}/${lang}/${app}-${version}.tar.bz2
    popd 2>&1 > /dev/null
  fi

  if [ ! -d /opt/${app} ] ;then
    [[ ! -d /opt ]] && mkdir -p /opt
    pushd /opt 2>&1 > /dev/null
    tar xpf /root/Downloads/${app}-${version}.tar.bz2
    popd 2>&1 > /dev/null
  fi
  if [ -L /usr/local/bin/${app} ] ;then
    sudo rm /usr/local/bin/${app}
  fi

  sudo ln -s /opt/${app}/${app} /usr/local/bin/${app}
  echo /usr/local/bin/${app}

  postinstall_remove_if_installed thunderbird lightning
}

function postinstall_utilities_wp34s {
  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads 2>&1 > /dev/null
  [[ ! -f wp-34s-emulator-linux64.tgz ]] \
    && wget -O ~/Downloads/wp-34s-emulator-linux64.tgz https://downloads.sourceforge.net/project/wp34s/emulator/wp-34s-emulator-linux64.tgz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fwp34s%2Ffiles%2Femulator%2F&ts=1509137814&use_mirror=netcologne
  popd 2>&1 > /dev/null

  if [ -f ~/Downloads/wp-34s-emulator-linux64.tgz ] ;then
    [[ ! -d /opt ]] && mkdir -p /opt
    pushd /opt 2>&1 > /dev/null
    tar -xf ~/Downloads/wp-34s-emulator-linux64.tgz
    popd 2>&1 > /dev/null
  fi
  
  if [ -L /usr/local/bin/WP-34s ] ;then
    sudo rm /usr/local/bin/WP-34s
  fi
      
  sudo ln -s /opt/wp-34s/WP-34s /usr/local/bin
  echo /usr/local/bin/WP-34S
}


##------------------------------------------


function postinstall_x11 {
  sudo apt-get install xclip gitk tortoisehg zeal -y
  sudo apt-get install chromium -y
  sudo apt-get install emacs25 -y
}

function postinstall_console {
  sudo apt-get install emacs25-nox -y
}


##------------------------------------------


postinstall_apt
postinstall_scm
postinstall_downloads
postinstall_compression
postinstall_networking
postinstall_editors
postinstall_source_code_utils
postinstall_firefox
postinstall_thunderbird
postinstall_utilities_wp34s
postinstall_parallelism
postinstall_virtualenv
postinstall_security_hardening

## dependent on graphical environments installed
if [[ $(dpkg-query -W xorg) ]] ;then
  postinstall_x11
else
  postinstall_console
fi


##------------------------------------------


apt-get autoremove --purge -y
apt-get autoclean
apt-get clean
