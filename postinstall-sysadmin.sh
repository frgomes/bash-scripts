#!/bin/bash -x

apt update -y
apt dist-upgrade -y
apt autoremove --purge -y

apt install -y


function postinstall_compression {
  apt install tar bsdtar bzip2 pbzip2 lbzip2 zstd lzip plzip xz-utils pxz pigz zip unzip p7zip p7zip-rar httrack -y

  #TODO: needs code review and tests!!!
  #[[ ! -e /usr/local/bin/bzip2   ]] && ln -s /usr/bin/lbzip2   /usr/local/bin/bzip2
  #[[ ! -e /usr/local/bin/bunzip2 ]] && ln -s /usr/bin/lbunzip2 /usr/local/bin/bunzip2
  #[[ ! -e /usr/local/bin/bzcat   ]] && ln -s /usr/bin/lbzcat   /usr/local/bin/bzcat
  #[[ ! -e /usr/local/bin/gzip    ]] && ln -s /usr/bin/pigz     /usr/local/bin/gzip
  #[[ ! -e /usr/local/bin/gunzip  ]] && ln -s /usr/bin/unpigz   /usr/local/bin/gunzip
  #[[ ! -e /usr/local/bin/lzip    ]] && ln -s /usr/bin/plzip    /usr/local/bin/lzip
  #[[ ! -e /usr/local/bin/xz      ]] && ln -s /usr/bin/pxz      /usr/local/bin/xz
}

function postinstall_scm {
  apt install git mercurial -y
}

function postinstall_downloads {
  apt install wget curl -y
}

function postinstall_editors {
  apt install zile vim -y
}

function postinstall_apt {
  apt install apt-file apt-transport-https apt-utils -y
  apt-file update
}

function postinstall_networking {
  apt install avahi-ui-utils kde-zeroconf avahi-utils cups-client avahi-daemon dnsutils nmap -y
}

function postinstall_virtualenv {
  apt install virtualenvwrapper -y
  source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
}

function postinstall_source_code_utils {
  apt install less source-highlight -y
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
    rm /usr/local/bin/WP-34s
  fi
      
  ln -s /opt/wp-34s/WP-34s /usr/local/bin
  echo /usr/local/bin/WP-34S
}

function postinstall_misc {
  apt install psmisc htop -y
}


##------------------------------------------


function postinstall_remove_java {
  apt remove -y --purge gcj-6 gcj-6-jdk gcj-6-jre gcj-6-jre-headless gcj-6-jre-lib default-jdk default-jdk-doc default-jdk-headless default-jre default-jre-headless openjdk-8-dbg openjdk-8-demo openjdk-8-doc openjdk-8-jdk openjdk-8-jdk-headless openjdk-8-jre openjdk-8-jre-headless openjdk-8-jre-zero
  apt autoremove -y --purge  
}


function postinstall_x11 {
  apt install xclip gitk tortoisehg zeal -y
  apt install chromium -y
  apt install emacs25 -y
}

function postinstall_console {
  apt install emacs25-nox -y
}


function postinstall_remove_smtp_servers {
  installed exim4-base && apt remove -y --purge exim4-daemon-light exim4-config exim4-base
}


##------------------------------------------


postinstall_misc
postinstall_apt
postinstall_scm
postinstall_downloads
postinstall_compression
postinstall_networking
postinstall_editors
postinstall_source_code_utils
postinstall_virtualenv

if [[ $(installed xorg) ]] ;then
  postinstall_remove_java
  postinstall_x11
  postinstall_utilities_wp34s
else
  postinstall_console
fi


##------------------------------------------


postinstall_remove_smtp_servers

apt autoremove --purge -y
apt autoclean
apt clean
