#!/bin/bash


function install_libvirt_working_folder {
  [[ ! -d /srv/lib/libvirt ]] && sudo mkdir -p /srv/lib/libvirt
  [[ ! -d /var/lib/libvirt ]] && sudo ln -s /srv/lib/libvirt /var/lib/libvirt
}

function install_libvirt {
  # install libvirt and vagrant
  sudo apt-get install libvirt-daemon libvirt-clients virt-top virtinst virt-manager vagrant vagrant-libvirt -y
}

function install_libvirt_user_enable {
  if [ ! -f ~/.ssh/id_rsa ] ;then
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
  fi

  sudo usermod -a -G libvirt ${USER}
  sudo usermod -a -G kvm     ${USER}

  sudo rmmod kvm_amd
  sudo rmmod kvm
  sudo modprobe kvm
  sudo modprobe kvm_amd
}


#install_libvirt_working_folder \
#  && install_libvirt \
#    && 
install_libvirt_user_enable
