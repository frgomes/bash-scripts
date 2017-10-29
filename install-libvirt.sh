#!/bin/bash


function install_libvirt_working_folder {
  [[ ! -d /srv/lib/libvirt ]] && sudo mkdir -p /srv/lib/libvirt
  [[ ! -d /var/lib/libvirt ]] && sudo ln -s /srv/lib/libvirt /var/lib/libvirt
  sudo chown -R libvirt-qemu:libvirt-qemu /srv/lib/libvirt
  sudo chown    libvirt-qemu:libvirt-qemu /var/lib/libvirt
}

function install_libvirt {
  # install libvirt and vagrant
  sudo apt-get install libvirt-daemon libvirt-clients virt-top virtinst virt-manager vagrant vagrant-libvirt -y
}

function install_libvirt_user_enable {
  if [ ! -f ~/.ssh/id_rsa ] ;then
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
  fi

  sudo usermod -a -G libvirt-qemu ${USER}

  # amd or intel or maybe arm or whatever?
  local cpu=amd

  # shake the tree
  sudo rmmod kvm_${cpu}
  sudo rmmod kvm
  sudo modprobe kvm
  sudo modprobe kvm_${cpu}
}


install_libvirt_working_folder \
  && install_libvirt \
    && install_libvirt_user_enable
