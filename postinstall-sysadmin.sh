#!/bin/bash -x


function installed {
  if [ "${1}" == "" ] ;then
    return 1
  else
    sudo apt list --installed $* 2> /dev/null
  fi
}

function uninstalled {
  if [ "${1}" == "" ] ;then
    return 1
  else
    fgrep -v -f <(sudo apt list --installed $* 2> /dev/null) <(sudo apt list $* 2> /dev/null)
  fi
}

function postinstall_compression {
  sudo apt install -y tar bzip2 pbzip2 lbzip2 zstd lzip plzip xz-utils xzdec pxz pigz zip unzip p7zip p7zip-rar httrack

  #TODO: needs code review and tests!!!
  #[[ ! -e /usr/local/bin/bzip2   ]] && ln -s /usr/bin/lbzip2   /usr/local/bin/bzip2
  #[[ ! -e /usr/local/bin/bunzip2 ]] && ln -s /usr/bin/lbunzip2 /usr/local/bin/bunzip2
  #[[ ! -e /usr/local/bin/bzcat   ]] && ln -s /usr/bin/lbzcat   /usr/local/bin/bzcat
  #[[ ! -e /usr/local/bin/gzip    ]] && ln -s /usr/bin/pigz     /usr/local/bin/gzip
  #[[ ! -e /usr/local/bin/gunzip  ]] && ln -s /usr/bin/unpigz   /usr/local/bin/gunzip
  #[[ ! -e /usr/local/bin/lzip    ]] && ln -s /usr/bin/plzip    /usr/local/bin/lzip
  #[[ ! -e /usr/local/bin/xz      ]] && ln -s /usr/bin/pxz      /usr/local/bin/xz
}

function postinstall_texlive {
  sudo apt install -y texlive-latex-base texlive-latex-extra texlive-latex-recommended
}

function postinstall_scm {
  sudo apt install -y git mercurial
}

function postinstall_downloads {
  sudo apt install -y wget curl
}

function postinstall_editors {
  sudo apt install -y zile vim
}

function postinstall_sudo apt {
  sudo apt install -y apt-file apt-transport-https apt-utils
  sudo apt-file update
}

function postinstall_python {
  sudo apt install -y python-pip virtualenvwrapper
}

function postinstall_networking {
  sudo apt install -y dnsmasq net-tools bridge-utils avahi-ui-utils kde-zeroconf avahi-utils cups-client avahi-daemon dnsutils nmap
}

function postinstall_source_code_utils {
  sudo apt install -y less source-highlight
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
  sudo apt install -y psmisc htop
}


##------------------------------------------


function postinstall_remove_java {
  sudo apt remove -y --purge gcj-6 gcj-6-jdk gcj-6-jre gcj-6-jre-headless gcj-6-jre-lib default-jdk default-jdk-doc default-jdk-headless default-jre default-jre-headless openjdk-8-dbg openjdk-8-demo openjdk-8-doc openjdk-8-jdk openjdk-8-jdk-headless openjdk-8-jre openjdk-8-jre-headless openjdk-8-jre-zero
  sudo apt autoremove -y --purge
  sudo apt install java-common -y
}


function postinstall_x11 {
  sudo apt install -y xclip
  sudo apt install -y zeal
  sudo apt install -y gitk
  sudo apt install -y tortoisehg
  sudo apt install -y chromium
  sudo apt install -y emacs25
}

function postinstall_console {
  sudo apt install -y emacs25-nox
}


function postinstall_remove_smtp_servers {
  installed exim4-base && sudo apt remove -y --purge exim4-daemon-light exim4-config exim4-base
}


##------------------------------------------


function postinstall_sysadmin {
  sudo apt update -y
  sudo apt dist-upgrade -y
  sudo apt autoremove --purge -y

  postinstall_misc
  postinstall_apt
  postinstall_scm
  postinstall_python
  postinstall_downloads
  postinstall_compression
  postinstall_texlive
  postinstall_networking
  postinstall_editors
  postinstall_source_code_utils

  installed   xorg && (postinstall_x11; postinstall_utilities_wp34s; postinstall_remove_java)
  uninstalled xorg && postinstall_console

  postinstall_remove_smtp_servers

  sudo apt autoremove --purge -y
  sudo apt autoclean
  sudo apt clean
}


postinstall_sysadmin
