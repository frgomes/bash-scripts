#!/bin/bash -x


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
  sudo apt-get install dnsutils nmap -y
}

function postinstall_printing {
  sudo apt-get install system-config-printer print-manager -y
}

function postinstall_virtualenv {
  sudo apt-get install virtualenvwrapper -y
  source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
}

function postinstall_source_code_utils {
  sudo apt-get install zeal wkhtmltopdf source-highlight -y
}

function postinstall_browser_chromium {
  sudo apt-get install chromium -y
}

function postinstall_browser_firefox {
  [[ ! -d $HOME/Downloads ]] && mkdir -p $HOME/Downloads
  local app=firefox
  local lang=$(echo $LANG | cut -d. -f1 | sed "s/_/-/")
  local hwarch=$(uname -m)
  local osarch=$(uname -s | tr [:upper:] [:lower:])
  local version=58.0

  if [ ! -e $HOME/Downloads/${app}-${version}.tar.bz2 ] ;then
    pushd $HOME/Downloads
    wget https://ftp.mozilla.org/pub/${app}/releases/${version}/${osarch}-${hwarch}/${lang}/${app}-${version}.tar.bz2
    popd
  fi

  if [ ! -d $HOME/tools/${app} ] ;then
    [[ ! -d $HOME/tools ]] && mkdir -p $HOME/tools
    pushd $HOME/tools
    tar xpf $HOME/Downloads/${app}-${version}.tar.bz2
    popd
  fi
  if [ -L /usr/local/bin/${app} ] ;then
    sudo rm /usr/local/bin/${app}
  fi

  sudo ln -s $HOME/tools/${app}/${app} /usr/local/bin/${app}
  echo /usr/local/bin/${app}
}

function postinstall_browser_thunderbird {
  [[ ! -d $HOME/Downloads ]] && mkdir -p $HOME/Downloads
  local app=thunderbird
  local lang=$(echo $LANG | cut -d. -f1 | sed "s/_/-/")
  local hwarch=$(uname -m)
  local osarch=$(uname -s | tr [:upper:] [:lower:])
  local version=58.0b3

  if [ ! -e $HOME/Downloads/${app}-${version}.tar.bz2 ] ;then
    pushd $HOME/Downloads
    wget https://ftp.mozilla.org/pub/${app}/releases/${version}/${osarch}-${hwarch}/${lang}/${app}-${version}.tar.bz2
    popd
  fi

  if [ ! -d $HOME/tools/${app} ] ;then
    [[ ! -d $HOME/tools ]] && mkdir -p $HOME/tools
    pushd $HOME/tools
    tar xpf $HOME/Downloads/${app}-${version}.tar.bz2
    popd
  fi
  if [ -L /usr/local/bin/${app} ] ;then
    sudo rm /usr/local/bin/${app}
  fi

  sudo ln -s $HOME/tools/${app}/${app} /usr/local/bin/${app}
  echo /usr/local/bin/${app}
}

function postinstall_browsers {
  postinstall_browser_chromium
  postinstall_browser_firefox
  postinstall_browser_thunderbird
}

function postinstall_utilities_wp34s {
  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads
  [[ ! -f wp-34s-emulator-linux64.tgz ]] \
    && wget -O ~/Downloads/wp-34s-emulator-linux64.tgz https://downloads.sourceforge.net/project/wp34s/emulator/wp-34s-emulator-linux64.tgz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fwp34s%2Ffiles%2Femulator%2F&ts=1509137814&use_mirror=netcologne
  popd

  if [ -f ~/Downloads/wp-34s-emulator-linux64.tgz ] ;then
    [[ ! -d $HOME/tools ]] && mkdir -p $HOME/tools
    pushd $HOME/tools
    tar -xf ~/Downloads/wp-34s-emulator-linux64.tgz
    popd
  fi
  
  if [ -L /usr/local/bin/WP-34s ] ;then
    sudo rm /usr/local/bin/WP-34s
  fi
      
  sudo ln -s $HOME/tools/wp-34s/WP-34s /usr/local/bin
  echo /usr/local/bin/WP-34S
}


sudo apt-get update -y
postinstall_apt
postinstall_networking
postinstall_downloads
postinstall_compression
postinstall_editors
postinstall_scm
postinstall_source_code_utils
postinstall_printing
postinstall_x11
postinstall_browsers
postinstall_utilities_wp34s
postinstall_parallelism
postinstall_virtualenv
postinstall_security_hardening
