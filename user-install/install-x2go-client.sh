#!/bin/bash -x

# Compiled from
#   https://wiki.x2go.org/doku.php/wiki:repositories:raspbian
#   https://wiki.x2go.org/doku.php/doc:installation:x2goclient

# See also: install_pulseaudio.sh


function install_x2go_client {
  sudo apt install lsb-release apt-transport-https dirmngr -y

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

  sudo apt update
  sudo apt install x2go-keyring -y && sudo apt update

  sudo apt install x2goclient plasma-widget-x2go -y
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
  echo $cmd
  $cmd
fi
