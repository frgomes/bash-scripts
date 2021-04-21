#!/bin/bash -eu

# Compiled from
#   https://wiki.x2go.org/doku.php/wiki:repositories:raspbian
#   https://wiki.x2go.org/doku.php/doc:installation:x2goclient

# See also: install_pulseaudio.sh


function install_x2go_client_binaries {
  sudo aptitude install -y lsb-release apt-transport-https dirmngr

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

  sudo aptitude update
  sudo aptitude install -y x2go-keyring && sudo aptitude update

  sudo aptitude install -y x2goclient plasma-widget-eu2go
}

function install_x2go_client {
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd $*
  done
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(grep -E "^function " $self | cut -d' ' -f2 | tail -1)
  $cmd $*
fi
