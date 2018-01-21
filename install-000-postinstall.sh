#!/bin/bash


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
  sudo apt-get install git gitk mercurial tortoisehg -y
}

function postinstall_downloads {
  sudo apt-get install wget curl -y
}

function postinstall_editors {
  sudo apt-get install zile emacs25 -y
}

function postinstall_parallelism {
  sudo apt-get install parallel -y
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

function postinstall_x11 {
  sudo apt-get install xclip -y
}

function postinstall_networking {
  sudo apt-get install dnsutils -y
}

function postinstall_virtualenv {
  sudo apt-get install virtualenvwrapper -y
  source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
}

function postinstall_source_code_utils {
  sudo apt-get install zeal wkhtmltopdf source-highlight -y
}


sudo apt-get update -y
postinstall_security_hardening
postinstall_apt
postinstall_compression
postinstall_scm
postinstall_downloads
postinstall_networking
postinstall_x11
postinstall_editors
postinstall_parallelism
postinstall_virtualenv
postinstall_source_code_utils
