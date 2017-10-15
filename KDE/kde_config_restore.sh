#!/bin/bash

source $HOME/bin/bash_21apt.sh

apt_install_no_prompt kmenuedit

cp -v ~/bin/KDE/menus/applications-kmenuedit.menu ~/.config/menus/applications-kmenuedit.menu
