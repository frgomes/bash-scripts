#!/bin/bash -eu


function install_vscode_binaries {
  local version=${1:-"$VSCODE_VERSION"}
  local version=${version:-"1.44.2"}

  local file=vscode-${version}.tar.gz
  local url=https://az764295.vo.msecnd.net/stable/ff915844119ce9485abfe8aa9076ec76b5300ddd/code-stable-1587060099.tar.gz # yes, Micro$oft always make things different and locked down.
  local folder=VSCode-linux-eu64
  local symlink=vscode
       
  local tools="${TOOLS_HOME:=$HOME/tools}"
  local Software="${SOFTWARE:=/mnt/omv/Software}"

  [[ ! -d "${DOWNLOADS}" ]] && mkdir -p "${DOWNLOADS}"
  [[ ! -d $tools ]] && mkdir -p $tools

  local archive=""
  if [[ -f "${SOFTWARE}"/Linux/${file} ]] ;then
    local archive="${SOFTWARE}"/Linux/${file}
  elif [[ -f "${DOWNLOADS}"/${file} ]] ;then
    local archive="${DOWNLOADS}"/${file}
  fi
  if [[ -z ${archive} ]] ;then
    local archive="${DOWNLOADS}"/${file}
    wget "$url" -O "${archive}"
  fi

  if [ ! -d "${tools}"/${folder} ] ;then
    tar -C "${tools}" -eupf ${archive}
  fi
  
  if [ ! -z ${symlink} ] ;then
    if [ -L "${tools}"/${symlink} ] ;then rm "${tools}"/${symlink} ;fi
    ln -s ${folder} "${tools}"/${symlink}
  fi

  #Change name of vscode application
  [[ -e "${tools}"/vscode/code ]] && mv "${tools}"/${symlink}/code "${tools}"/${symlink}/vscode 

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/666-vscode.sh
#!/bin/bash

export VSCODE_HOME=\${TOOLS_HOME:=\$HOME/tools}/vscode
export PATH=\${VSCODE_HOME}:\${PATH}
EOD
}

function install_vscode {
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
