#!/bin/bash


function install_gradle_binaries {
  local version=${1:-"$GRADLE_VERSION"}
  local version=${version:-"4.10.2"}

  local major=$( echo ${version} | cut -d. -f 1-2 )

  [[ ! -d "${DOWNLOADS}" ]] && mkdir -p "${DOWNLOADS}"
  pushd "${DOWNLOADS}" > /dev/null
  [[ ! -f gradle-${version}-bin.zip ]] && wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
  popd > /dev/null

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/gradle-${version} ] ;then
    pushd ${tools} > /dev/null
    unzip "${DOWNLOADS}"/gradle-${version}-bin.zip
    popd > /dev/null
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/332-gradle.sh
#!/bin/bash

export GRADLE_VERSION=${version}
export GRADLE_HOME=\${TOOLS_HOME:=\$HOME/tools}/gradle-\${GRADLE_VERSION}

export PATH=\${GRADLE_HOME}/bin:\${PATH}
EOD
}

function install_gradle {
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
