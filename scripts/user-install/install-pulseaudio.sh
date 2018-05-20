#!/bin/bash -x

function install_pulseaudio_raspbian_firmware_update {
  local machine=$(uname -m)
  if [ "${machine}" == "armv7l" ] ;then
      # Update all Raspbian packages.
      # Do this *before* the firmware update.
      sudo apt update
      sudo apt upgrade -y

      # Install rpi-update as described at
      # https://github.com/Hexxeh/rpi-update
      sudo apt install git-core -y
      sudo wget https://raw.github.com/Hexxeh/rpi-update/master/rpi-update -O /usr/bin/rpi-update
      sudo chmod +x /usr/bin/rpi-update

      # Backup the existing firmware.
      sudo cp /boot/start.elf /boot/start.elf.knowngood

      # Update to the latest firmware and activate it.
      sudo rpi-update
  fi
}

function install_pulseaudio_packages {
  sudo apt install pulseaudio pulseaudio-utils -y
}


install_pulseaudio_raspbian_firmware_update && install_pulseaudio_packages
