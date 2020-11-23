#!/bin/bash


function install_openmediavault_postfix {
  # Substitute server, username and password below by your own settings
  SERVER=smtp.gmail.com
  USERNAME=your.username@gmail.com
  PASSWORD=your.password
   
  sudo aptitude install -y postfix sasl2-bin bsd-mailx
   
  sudo cp -p /etc/postfix/main.cf /etc/postfix/main.cf.ORIGINAL

sudo tee /etc/postfix/main.cf > /dev/null << EOD
smtp_use_tls = yes
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_mechanism_filter = plain, login
smtp_sasl_security_options = noanonymous
EOD

sudo tee /etc/postfix/sasl_passwd > /dev/null << EOD
${SERVER} ${USERNAME}:${PASSWORD}
EOD

  sudo chmod 400 /etc/postfix/sasl_passwd

  sudo postmap /etc/postfix/sasl_passwd
  sudo /etc/init.d/postfix restart
}


function install_openmediavault_binaries {
  sudo bash -c 'echo "deb http://packages.openmediavault.org/public erasmus main" > /etc/apt/sources.list.d/openmediavault.list'
  sudo aptitude update
   
  sudo aptitude install -y openmediavault-keyring 
  sudo aptitude update
   
  sudo aptitude install -y \
          --yes --force-yes --auto-remove --show-upgraded \
          --no-install-recommends \
          --option Dpkg::Options::="--force-confdef" \
          --option DPkg::Options::="--force-confold" \
          openmediavault
   
  sudo omv-initsystem
}

function install_openmediavault {
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
