#!/bin/bash


function install_libvirt_binaries {
  [[ ! -d /srv/lib/libvirt ]] && mkdir -p /srv/lib/libvirt
  [[ ! -d /var/lib/libvirt ]] && ln -s /srv/lib/libvirt /var/lib/libvirt
  sudo apt install libvirt-daemon libvirt-daemon-system -y
}

function install_libvirt_modprobe {
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

function install_libvirt_clients {
  sudo apt install virt-manager libvirt-clients virt-top xmlstarlet uuid-runtime -y
}


function install_libvirt {
    install_libvirt_binaries && install_libvirt_modprobe && install_libvirt_clients
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  fgrep "function " $self | cut -d' ' -f2 | head -n -2
else
  # echo "Script is a subshell"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  cmd=$(fgrep "function " $self | cut -d' ' -f2 | head -n -2 | tail -1)
  # echo $cmd
  $cmd $*
fi
