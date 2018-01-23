#!/bin/bash


function install_libvirt_working_folder {
  [[ ! -d /srv/lib/libvirt ]] && sudo mkdir -p /srv/lib/libvirt
  [[ ! -d /var/lib/libvirt ]] && sudo ln -s /srv/lib/libvirt /var/lib/libvirt
  return 0
}

function install_libvirt {
  # install libvirt and vagrant
  sudo apt-get install libvirt-daemon libvirt-clients virt-top virtinst virt-manager libosinfo-bin libguestfs-tools virt-top vagrant vagrant-libvirt -y
  sudo chown libvirt-qemu:libvirt-qemu /var/lib/libvirt /srv/lib/libvirt
}

function install_libvirt_user_enable {
  if [ ! -f ~/.ssh/id_rsa ] ;then
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
  fi

  sudo usermod -a -G libvirt-qemu ${USER}

  case $( cat /proc/cpuinfo | fgrep vendor_id | head -1 | sed -E 's/[ \t]+/ /g' | cut -d' ' -f3 ) in
    AuthenticAMD) local cpu=amd   ;;
    GenuineIntel) local cpu=intel ;;
    *) local cpu=unknown ;;
  esac

  # shake the tree
  sudo rmmod kvm_${cpu}
  sudo rmmod kvm
  sudo modprobe kvm
  sudo modprobe kvm_${cpu}
}


install_libvirt_working_folder \
  && install_libvirt \
    && install_libvirt_user_enable
