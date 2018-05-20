#!/bin/bash -x

# Compiled from
#   https://wiki.x2go.org/doku.php/wiki:repositories:debian
#   https://wiki.x2go.org/doku.php/doc:installation:x2goserver
#   https://wiki.x2go.org/doku.php/doc:installation:printing

# See also: install_pulseaudio.sh


function install_x2go_server {
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
  sudo apt-key adv --recv-keys keys.gnupg.net E1F958385BFE2B6E

  sudo apt update
  sudo apt install x2go-keyring -y && sudo apt update
  
  sudo apt install x2goserver x2goserver-xsession x2godesktopsharing x2goserver-printing cups cups-x2go -y
}

function install_x2go_configure_printer {
  sudo lpadmin -p "X2GO" -D "Virtual X2Go Printer" -E -v cups-x2go:/ -m lsb/usr/cups-x2go/CUPS-X2GO.ppd
}


install_x2go_server && install_x2go_configure_printer
