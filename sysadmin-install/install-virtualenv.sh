#!/bin/bash

function postinstall_virtualenv {
  apt install virtualenvwrapper -y
  source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
}

postinstall_virtualenv
