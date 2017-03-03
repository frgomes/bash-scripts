#!/bin/bash

[[ ! $(dpkg --list | fgrep network-manager) ]] && sudo apt-get install network-manager -y
[[ ! $(dpkg --list | fgrep wireless-tools)  ]] && sudo apt-get install wireless-tools -y


function nmcli_list {
  nmcli --pretty --fields NAME,UUID,TIMESTAMP-REAL con show
}

function nmcli_remove {
  if [ ! -z "$1" ] ;then
    nmcli --fields NAME con show | \
      grep "$@" | \
        while read name ;do 
          echo Removing SSID "$name"
          nmcli con delete "$name"
        done
  fi
}

##################################################################################
# The intent here is avoid that a connection named "never drive after you drink" #
# matches a timestamp "never". So, we have to make sure that we match colon      #
# followed by "never" followed by spaces and/or tabs and finally an end of line. #
#                                                                                #
# WARNING: However, I didn't get a chance to test this scenario.                 #
#          So, I provide this code the way it is, in the hope that I've covered  #
#          well the behavior from some other simulations I did.                  #
##################################################################################
function nmcli_remove_never_used {
  nmcli --terse --fields NAME,TIMESTAMP-REAL con show | \
    egrep -e ':never[ \t]*$' | \
      sed -r 's/:never[ \t]*$//' | \
        while read name ;do
          echo Removing SSID "$name"
          nmcli con delete "$name"
        done
}

function nmcli_connected_wifi {
  nmcli -t -f active,ssid dev wifi | fgrep yes: | cut -d: -f2
}
