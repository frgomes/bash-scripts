#!/bin/bash


function install_libvirt {
  [[ ! -d /srv/lib/libvirt ]] && mkdir -p /srv/lib/libvirt
  [[ ! -d /var/lib/libvirt ]] && ln -s /srv/lib/libvirt /var/lib/libvirt
  apt-get install libvirt-daemon libvirt-clients virt-top vagrant vagrant-libvirt -y

  ##XXX apt-get install libvirt-daemon libvirt-clients virt-top virtinst libosinfo-bin libguestfs-tools vagrant vagrant-libvirt -y
  ##XXX chown libvirt-qemu:libvirt-qemu /var/lib/libvirt /srv/lib/libvirt
}

function install_libvirt_modprobe {
  case $( cat /proc/cpuinfo | fgrep vendor_id | head -1 | sed -E 's/[ \t]+/ /g' | cut -d' ' -f3 ) in
    AuthenticAMD) local cpu=amd   ;;
    GenuineIntel) local cpu=intel ;;
    *) local cpu=unknown ;;
  esac

  # shake the tree
  rmmod kvm_${cpu}
  rmmod kvm
  modprobe kvm
  modprobe kvm_${cpu}
}


install_libvirt && install_libvirt_modprobe
