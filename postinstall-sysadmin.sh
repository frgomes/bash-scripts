#!/bin/bash -x


function __installed {
  if [ "${1}" == "" ] ;then
    return 1
  else
    sudo apt list --installed $* 2> /dev/null
  fi
}

function __uninstalled {
  if [ "${1}" == "" ] ;then
    return 1
  else
    fgrep -v -f <(sudo apt list --installed $* 2> /dev/null) <(sudo apt list $* 2> /dev/null)
  fi
}

function postinstall_compression {
  sudo apt install -y atool arc arj lzip lzop nomarch rar rpm unace unalz unrar lbzip2 zip unzip p7zip p7zip-rar unrar-free

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

function postinstall_sudo_apt {
  sudo apt install -y apt-file apt-transport-https apt-utils
  sudo apt-file update
}

function postinstall_python {
  sudo apt install -y python3-pip virtualenvwrapper
}

function postinstall_networking {
  sudo apt install -y dnsmasq net-tools bridge-utils avahi-ui-utils kde-zeroconf avahi-utils cups-client avahi-daemon dnsutils nmap
}

function postinstall_source_code_utils {
  sudo apt install -y less source-highlight
}

function postinstall_http_utils {
  sudo apt install -y httrack
}

function __postinstall_x11_utilities_wp34s {
  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads 2>&1 > /dev/null
  [[ ! -f wp-34s-emulator-linux64.tgz ]] \
    && wget -O ~/Downloads/wp-34s-emulator-linux64.tgz https://downloads.sourceforge.net/project/wp34s/emulator/wp-34s-emulator-linux64.tgz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fwp34s%2Ffiles%2Femulator%2F&ts=1509137814&use_mirror=netcologne
  popd 2>&1 > /dev/null

  if [ -f ~/Downloads/wp-34s-emulator-linux64.tgz ] ;then
    [[ ! -d /opt ]] && mkdir -p /opt
    pushd /opt 2>&1 > /dev/null
    sudo tar -xf ~/Downloads/wp-34s-emulator-linux64.tgz
    popd 2>&1 > /dev/null
  fi
  
  if [ -L /usr/local/bin/WP-34s ] ;then
    sudo rm /usr/local/bin/WP-34s
  fi
      
  sudo ln -s /opt/wp-34s/WP-34s /usr/local/bin
  echo /usr/local/bin/WP-34S
}

function postinstall_x11_utilities_wp34s {
  installed xorg && __postinstall_x11_utilities_wp34s
}

function postinstall_misc {
  sudo apt install -y psmisc htop
}


##------------------------------------------


function __postinstall_x11 {
  sudo apt install -y xclip
  sudo apt install -y zeal
  sudo apt install -y gitk
  sudo apt install -y tortoisehg
  sudo apt install -y chromium
}

function postinstall_x11 {
  installed xorg && __postinstall_x11
}


function postinstall_remove_smtp_servers {
  __installed exim4-base && sudo apt remove -y --purge exim4-daemon-light exim4-config exim4-base
}

function postinstall_install_development_libraries {
  sudo apt install -v libssl-dev
}


##------------------------------------------


function postinstall_sysadmin {
  sudo apt update -y
  sudo apt dist-upgrade -y
  sudo apt autoremove --purge -y

  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd
  done

  sudo apt autoremove --purge -y
  sudo apt autoclean
  sudo apt clean
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
