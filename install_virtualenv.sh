#!/bin/bash

function 
sudo apt-get install virtualenvwrapper -y

source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
hash -r

mkvirtualenv -p /usr/bin/python3 j8s11
mkvirtualenv -p /usr/bin/python3 j8s12
