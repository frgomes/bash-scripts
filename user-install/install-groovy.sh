#!/bin/bash


function install_groovy_binaries {
  local version=${1:-"$GROOVY_VERSION"}
  local version=${version:-"2.5.0"}

  local major=$( echo ${version} | cut -d. -f 1-2 )

  [[ ! -d "${DOWNLOADS}" ]] && mkdir -p "${DOWNLOADS}"
  pushd "${DOWNLOADS}" > /dev/null
  [[ ! -f apache-groovy-sdk-${version}.zip ]] && wget https://dl.bintray.com/groovy/maven/apache-groovy-sdk-${version}.zip
  popd > /dev/null

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/groovy-${version} ] ;then
    pushd ${tools} > /dev/null
    unzip "${DOWNLOADS}"/apache-groovy-sdk-${version}.zip
    popd > /dev/null
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/340-groovy.sh
#!/bin/bash

export GROOVY_VERSION=${version}
export GROOVY_HOME=\${TOOLS_HOME:=\$HOME/tools}/groovy-\${GROOVY_VERSION}

export PATH=\${GROOVY_HOME}/bin:\${PATH}
EOD
}

function install_groovy {
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
