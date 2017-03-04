#!/bin/bash

function install_postfix {
  # Substitute server, username and password below by your own settings
  SERVER=smtp.gmail.com
  USERNAME=your.username@gmail.com
  PASSWORD=your.password
   
  sudo apt-get install postfix sasl2-bin bsd-mailx -y
   
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


function install_openmediavault {
  sudo bash -c 'echo "deb http://packages.openmediavault.org/public erasmus main" > /etc/apt/sources.list.d/openmediavault.list'
  sudo apt-get update
   
  sudo apt-get install openmediavault-keyring 
  sudo apt-get update
   
  sudo apt-get install \
          --yes --force-yes --auto-remove --show-upgraded \
          --no-install-recommends \
          --option Dpkg::Options::="--force-confdef" \
          --option DPkg::Options::="--force-confold" \
          openmediavault
   
  sudo omv-initsystem
}

install_postfix
install_openmediavault
