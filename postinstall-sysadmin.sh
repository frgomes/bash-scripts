#!/bin/bash -eu


function __installed {
  if [ "${1}" == "" ] ;then
    return 1
  else
    sudo aptitude list -i $* 2> /dev/null
  fi
}

function __uninstalled {
  if [ "${1}" == "" ] ;then
    return 1
  else
    fgrep -v -f <(sudo aptitude list -i $* 2> /dev/null) <(sudo aptitude list $* 2> /dev/null)
  fi
}

function postinstall_compression {
  sudo aptitude install -y atool arc arj lzip lzop nomarch rar rpm unace unalz unrar lbzip2 zip unzip p7zip p7zip-rar unrar-free

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
  sudo aptitude install -y texlive-latex-base texlive-latex-extra texlive-latex-recommended
}

function postinstall_scm {
  sudo aptitude install -y git
}

function postinstall_downloads {
  sudo aptitude install -y wget curl
}

function postinstall_editors {
  sudo aptitude install -y zile vim
}

function postinstall_sudo_apt {
  case "$(lsb_release -si)" in
    Debian) sudo apt install -y aptitude;;
    openSUSE) sudo zypper install -y zypper-aptitude;;
  esac
}

function postinstall_networking {
  sudo aptitude install -y dnsmasq net-tools bridge-utils avahi-ui-utils kde-zeroconf avahi-utils cups-client avahi-daemon dnsutils nmap
}

function postinstall_source_code_utils {
  sudo aptitude install -y less source-highlight
}

function postinstall_http_utils {
  sudo aptitude install -y httrack
}

function postinstall_misc {
  sudo aptitude install -y psmisc htop
}


##------------------------------------------


function __postinstall_x11 {
  sudo aptitude install -y xclip
  sudo aptitude install -y zeal
  sudo aptitude install -y gitk
  sudo aptitude install -y tortoisehg
  sudo aptitude install -y chromium
}

function postinstall_x11 {
  installed xorg && __postinstall_x11
}


function postinstall_remove_smtp_servers {
  __installed exim4-base && sudo aptitude remove exim4-daemon-light exim4-config exim4-base
}

function postinstall_install_development_libraries {
  sudo aptitude install -y -v libssl-dev
}


##------------------------------------------


function postinstall_sysadmin {
  sudo aptitude update
  sudo aptitude dist-upgrade

  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd
  done

  sudo aptitude clean
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
