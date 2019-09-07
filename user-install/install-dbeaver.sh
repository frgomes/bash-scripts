#!/bin/bash


function install_dbeaver {
  local version=${1:-"$DBEAVER_VERSION"}
  local version=${version:-"6.1.5"}

  local url=https://dbeaver.io/files/${version}/dbeaver-ce-${version}-linux.gtk.x86_64.tar.gz
  local file=~/Downloads/dbeaver-ce-${version}-linux.gtk.x86_64.tar.gz
  local folder=dbeaver

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  [[ ! -f ${file} ]] && wget ${url} -O ${file}

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p $tools
  [[ ! -d ${tools}/${folder} ]] 
  tar -C ${tools} -xf ${file}

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/380-dbeaver.sh
#!/bin/bash

export PATH=${tools}/${folder}:\${PATH}
EOD
  
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
