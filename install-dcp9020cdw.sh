#!/bin/bash -x

source $HOME/bin/bash_20functions.sh

function install_dcp9020cdw_packages {
  download http://download.brother.com/welcome/dlf100441/dcp9020cdwlpr-1.1.2-1.i386.deb
  download http://download.brother.com/welcome/dlf100443/dcp9020cdwcupswrapper-1.1.4-0.i386.deb
  download http://download.brother.com/welcome/dlf006645/brscan4-0.4.4-4.amd64.deb
  download http://download.brother.com/welcome/dlf006652/brscan-skey-0.2.4-1.amd64.deb
  download http://download.brother.com/welcome/dlf006654/brother-udev-rule-type1-1.0.2-0.all.deb

  if [ -f $HOME/Downloads/dcp9020cdwlpr-1.1.2-1.i386.deb -a \
       -f $HOME/Downloads/dcp9020cdwcupswrapper-1.1.4-0.i386.deb -a \
       -f $HOME/Downloads/brscan4-0.4.4-4.amd64.deb -a \
       -f $HOME/Downloads/brscan-skey-0.2.4-1.amd64.deb -a \
       -f $HOME/Downloads/brother-udev-rule-type1-1.0.2-0.all.deb ] ;then \
    sudo dpkg --add-architecture i386 && \
    sudo apt-get update && \
    sudo apt-get install lib32stdc++6 libkf5kdelibs4support5-bin libnotify-bin kio-extras nomacs sane-utils psutils gscan2pdf -y && \
    sudo dpkg --install --force-all \
          $HOME/Downloads/dcp9020cdwlpr-1.1.2-1.i386.deb \
          $HOME/Downloads/dcp9020cdwcupswrapper-1.1.4-0.i386.deb \
          $HOME/Downloads/brscan4-0.4.4-4.amd64.deb \
          $HOME/Downloads/brscan-skey-0.2.4-1.amd64.deb \
          $HOME/Downloads/brother-udev-rule-type1-1.0.2-0.all.deb && \
    sudo apt-get -f install
  else
    echo ERROR: Could not download installation packages
    return 1
  fi
}

function install_dcp9020cdw_configure_scanner {
  local IP=$(getent hosts dcp9020cdw.localdomain | awk '{ print $1 }')
  hash -r && \
  sudo brsaneconfig4 -a name=DCP9020CDW model=DCP-9020CDW ip=${IP} && \
  brscan-skey -l
}

function install_dcp9020cdw_service_menus {
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
  install_dcp9020cdw_service_menus > $dir5/ServiceMenus/convert_pnm.desktop
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


install_dcp9020cdw_packages && \
  install_dcp9020cdw_configure_scanner && \
    install_dcp9020cdw_configure_dolphin && \
      install_dcp9020cdw_configure_autostart
