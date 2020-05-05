#!/bin/bash

source ~/scripts/bash_20functions.sh

function install_cdp9020cdw_requirements {
  local ip=$(getent ahostsv4 dcp9020cdw | head -1 | cut -d' ' -f1)
  if [ ! -z "$ip" ] ;then
    [[ ! $( dpkg -s lib32stdc++6 > /dev/null 2>&1 ) ]] \
      && sudo dpkg --add-architecture i386 \
      && sudo apt update \
      && sudo apt install lib32stdc++6 -y 
  else
    echo ERROR: please make sure that IP address dcp9020cdw can be resolved.
    return 1
  fi
}

function install_dcp9020cdw_packages {
  download http://download.brother.com/welcome/dlf100441/dcp9020cdwlpr-1.1.2-1.i386.deb
  download http://download.brother.com/welcome/dlf100443/dcp9020cdwcupswrapper-1.1.4-0.i386.deb
  download http://download.brother.com/welcome/dlf006645/brscan4-0.4.4-4.amd64.deb
  download http://download.brother.com/welcome/dlf006652/brscan-skey-0.2.4-1.amd64.deb
  download http://download.brother.com/welcome/dlf006654/brother-udev-rule-type1-1.0.2-0.all.deb

  if [ -f "${DOWNLOADS}"/dcp9020cdwlpr-1.1.2-1.i386.deb -a \
       -f "${DOWNLOADS}"/dcp9020cdwcupswrapper-1.1.4-0.i386.deb -a \
       -f "${DOWNLOADS}"/brscan4-0.4.4-4.amd64.deb -a \
       -f "${DOWNLOADS}"/brscan-skey-0.2.4-1.amd64.deb -a \
       -f "${DOWNLOADS}"/brother-udev-rule-type1-1.0.2-0.all.deb ] ;then \
    [[ ! -d /var/spool/lpd/dcp9020cdw ]] && sudo mkdir -p /var/spool/lpd/dcp9020cdw
    sudo apt install libkf5kdelibs4support5-bin libnotify-bin kio-extras nomacs skanlite sane-utils psutils gscan2pdf -y \
    && sudo dpkg --install --force-all \
          "${DOWNLOADS}"/dcp9020cdwlpr-1.1.2-1.i386.deb \
          "${DOWNLOADS}"/dcp9020cdwcupswrapper-1.1.4-0.i386.deb \
          "${DOWNLOADS}"/brscan4-0.4.4-4.amd64.deb \
          "${DOWNLOADS}"/brscan-skey-0.2.4-1.amd64.deb \
          "${DOWNLOADS}"/brother-udev-rule-type1-1.0.2-0.all.deb \
    && sudo apt install -y -f
  else
    echo ERROR: Could not download installation packages
    return 1
  fi
}

function install_dcp9020cdw_configure_scanner {
  local IP=$(getent hosts dcp9020cdw | awk '{ print $1 }')
  hash -r && \
  sudo brsaneconfig4 -a name=DCP9020CDW model=DCP-9020CDW ip=${IP} && \
  brscan-skey -l
}

function __install_dcp9020cdw_service_menus {
cat <<EOD
[Desktop Entry]
Type=Service
Encoding=UTF-8
ServiceTypes=KonqPopupMenu/Plugin
MimeType=image/x-portable-anymap
Actions=Convert2PNG;Convert2PDF

[Desktop Action Convert2PNG]
Name=Convert to PNG
Exec=convert %f $(basename %f .pnm).png
Icon=background

[Desktop Action Convert2PDF]
Name=Convert to PDF
Exec=convert %f $(basename %f .pnm).pdf
Icon=background
EOD
}

function install_dcp9020cdw_configure_dolphin {
  dir5=$(kf5-config  --path services | cut -d: -f1) && \
  [[ ! -f $dir5/ServiceMenus ]] && mkdir -p $dir5/ServiceMenus && \
  __install_dcp9020cdw_service_menus > $dir5/ServiceMenus/convert_pnm.desktop
}

function install_dcp9020cdw_autostart {
cat <<EOD
[Desktop Entry]
Comment=
Exec=brscan-skey -a DCP9020CDW
GenericName=
Hidden=false
Icon=system-run
MimeType=
Name=
Path=
StartupNotify=true
Terminal=false
TerminalOptions=
Type=Application
X-DBUS-ServiceName=
X-DBUS-StartupType=
X-KDE-SubstituteUID=false
X-KDE-Username=
EOD
}

function install_dcp9020cdw_configure_autostart {
  [[ ! -f $HOME/.config/autostart ]] && mkdir -p $HOME/.config/autostart && \
  install_dcp9020cdw_autostart > $HOME/.config/autostart/brscan-skey.desktop
}


function install_dcp9020dcw {
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
