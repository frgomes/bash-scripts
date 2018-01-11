#!/bin/bash -x

# Compiled from
#   https://wiki.x2go.org/doku.php/wiki:repositories:raspbian
#   https://wiki.x2go.org/doku.php/doc:installation:x2goclient

# See also: install_pulseaudio.sh


function install_x2go_client {
  sudo apt-get install lsb-release apt-transport-https dirmngr -y

  local machine=$(uname -m)
  case "${machine}" in
    armv7l)
      local distro=raspbian
        ;;
    *)
      local distro=debian
        ;;
  esac

  local release=$(lsb_release -cs)
  echo deb http://packages.x2go.org/${distro} ${release} main | sudo tee /etc/apt/sources.list.d/x2go.list
  sudo apt-key adv --recv-keys --keyserver keys.gnupg.net E1F958385BFE2B6E

  sudo apt-get update
  sudo apt-get install x2go-keyring -y && sudo apt-get update

  sudo apt-get install x2goclient -y
}


install_x2go_client
