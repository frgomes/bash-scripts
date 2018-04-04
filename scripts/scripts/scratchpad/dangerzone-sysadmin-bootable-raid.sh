#!/bin/bash

function mdadm_bootable_raid {
  if [ $# -lt 2 ] ;then
    echo 'Usage:   mdadm_bootable_raid <source> <mirror>'
    echo 'Example: mdadm_bootable_raid /dev/sda /dev/sdh'
  else
    local source=$1
    local mirror=$2

    echo "DANGER, DANGER, DANGER Will Robinson!"
    echo "The partition table of ${mirror} will be completely and permanently destroyed."
    echo "All data sitting on ${mirror} will be completely and permanently lost."
    read -p "Are you sure you want to proceed? y/N: " confirm

    if [ "$confirm" == "y" ] ;then
      sfdisk -d ${source} | sfdisk ${mirror}
      echo 50000 > /proc/sys/dev/raid/speed_limit_min
      echo 5000000 > /proc/sys/dev/raid/speed_limit_max
      mdadm --create /dev/md/0 --level=1 --metadata=1.0 --raid-devices=2  ${source}1 ${mirror}1
      mdadm --create /dev/md/1 --level=1                --raid-devices=2  ${source}5 ${mirror}5
      watch cat /proc/mdstat
    fi
  fi
}

