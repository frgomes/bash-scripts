#!/bin/bash

function apt_autoremove_purge_all {
  sudo apt-get autoremove --purge -y $(dpkg -l | grep '^rc' | awk '{print $2}')
}
