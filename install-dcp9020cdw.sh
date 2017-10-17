#!/bin/bash

source $HOME/bin/bash_20functions.sh

download http://download.brother.com/welcome/dlf100441/dcp9020cdwlpr-1.1.2-1.i386.deb
download http://download.brother.com/welcome/dlf100443/dcp9020cdwcupswrapper-1.1.4-0.i386.deb
download http://download.brother.com/welcome/dlf006645/brscan4-0.4.4-4.amd64.deb
download http://download.brother.com/welcome/dlf006652/brscan-skey-0.2.4-1.amd64.deb
download http://download.brother.com/welcome/dlf006654/brother-udev-rule-type1-1.0.2-0.all.deb

IP=$(getent hosts dcp9020cdw.localdomain | awk '{ print $1 }')

sudo dpkg --add-architecture i386 && \
sudo apt-get update && \
sudo apt-get install lib32stdc++6 sane-utils psutils gscan2pdf libnotify-bin imagemagick -y && \
sudo dpkg --add-architecture i386 && \
sudo apt-get update && \
sudo apt-get install lib32stdc++6 nomacs sane-utils psutils gscan2pdf -y && \
sudo dpkg --install --force-all \
        $HOME/Downloads/dcp9020cdwlpr-1.1.2-1.i386.deb \
        $HOME/Downloads/dcp9020cdwcupswrapper-1.1.4-0.i386.deb \
        $HOME/Downloads/brscan4-0.4.4-4.amd64.deb \
        $HOME/Downloads/brscan-skey-0.2.4-1.amd64.deb \
        $HOME/Downloads/brother-udev-rule-type1-1.0.2-0.all.deb && \
sudo apt-get -f install && \
hash -r && \
sudo brsaneconfig4 -a name=DCP9020CDW model=DCP-9020CDW ip=${IP} && \
brscan-skey -l && \
brscan-skey -a DCP9020CDW
