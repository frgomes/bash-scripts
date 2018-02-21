#!/bin/bash


function postinstall_sysadmin_libvirt {
  [[ ! -d /srv/lib/libvirt ]] && mkdir -p /srv/lib/libvirt
  [[ ! -d /var/lib/libvirt ]] && ln -s /srv/lib/libvirt /var/lib/libvirt
  apt-get install libvirt-daemon libvirt-clients virt-top xmlstarlet uuid-runtime -y
}

function postinstall_sysadmin_libvirt_modprobe {
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

function postinstall_sysadmin_libvirt_vagrant {
  local version=${VAGRANT_VERSION:=2.0.2}
  local arch=x86_64
  local ext=deb
  local archive=/root/Downloads/vagrant_${version}_${arch}.${ext}

  [[ ! -d /root/Downloads ]] && mkdir /root/Downloads
  [[ ! -f $archive} ]] && \
    wget https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}_${arch}.${ext} -O ${archive}

  dpkg -i ${archive}

  apt-get build-dep vagrant ruby-libvirt -y
  apt-get install qemu libvirt-bin ebtables dnsmasq -y
  apt-get install libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev -y

  vagrant plugin install vagrant-libvirt
}


postinstall_sysadmin_libvirt && \
  postinstall_sysadmin_libvirt_modprobe && \
    postinstall_sysadmin_libvirt_vagrant
