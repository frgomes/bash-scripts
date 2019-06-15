#!/bin/bash


##
## FIXME: There's hardcode in this function :-(
##
function install_java {
  echo "================================================================================"
  echo "                                                                                "
  echo "In case you need a specific version of the JDK:                                 "
  echo "                                                                                "
  echo "    Oracle now requires username and password in order to download the JDK.     "
  echo "    Unfortunately, this script cannot help you install the JDK automatically.   "
  echo "    You will have to download and install the JDK manually and update variables "
  echo "    JAVA_VERSION and JAVA_HOME in your virtualenv profiles.                     "
  echo "                                                                                "
  echo "In case you don't need a specific version of the JDK:                           "
  echo "                                                                                "
  echo "    Simply install a default version of the OpenJDK for your distribution:      "
  echo "    $ sudo apt install default-jdk default-jdk-headless                         "
  echo "                                                                                "
  echo "================================================================================"
  echo ""
  echo "This scripts that you'd like to install a default version of the JDK"
  echo ""
  echo "sudo apt install default-jdk default-jdk-headless"
  sudo apt install default-jdk default-jdk-headless
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
  # echo $cmd
  $cmd $*
fi
