#!/bin/bash -eu


function postinstall_compression {
  apt+ install atool arc arj lzip lzop nomarch rar rpm unace unalz unrar lbzip2 zip unzip p7zip p7zip-rar unrar-free

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
  apt+ install texlive-latex-base texlive-latex-extra texlive-latex-recommended
}

function postinstall_scm {
  apt+ install git
}

function postinstall_downloads {
  apt+ install wget curl
}

function postinstall_editors {
  apt+ install zile vim
}

function postinstall_networking {
  apt+ install dnsmasq net-tools bridge-utils avahi-ui-utils kde-zeroconf avahi-utils cups-client avahi-daemon dnsutils nmap
}

function postinstall_source_code_utils {
  apt+ install less source-highlight
}

function postinstall_http_utils {
  apt+ install httrack
}

function postinstall_misc {
  apt+ install psmisc htop
}


##------------------------------------------


function __postinstall_x11 {
  apt+ install xclip
  apt+ install zeal
  apt+ install gitk
  apt+ install tortoisehg
  apt+ install chromium
}

function postinstall_x11 {
  which xinput && __postinstall_x11
}


function postinstall_remove_smtp_servers {
  apt+ remove exim4-daemon-light exim4-config exim4-base
}

function postinstall_install_development_libraries {
  apt+ install libssl-dev
}


##------------------------------------------


function postinstall_sysadmin {
  apt+ update
  apt+ dist-upgrade

  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd
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
