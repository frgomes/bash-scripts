#!/bin/bash

function install_bfg_download {
  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads > /dev/null
  [[ ! -f bfg-1.12.16.jar ]] \
    && wget -O ~/Downloads/bfg-1.12.16.jar http://repo1.maven.org/maven2/com/madgag/bfg/1.12.16/bfg-1.12.16.jar
  popd > /dev/null
}

function __install_bfg_script {
cat << EOD
#!/bin/bash

java -jar /opt/lib/bfg-1.12.16.jar $*
EOD
}

function install_bfg_binaries {
  if [ -f ~/Downloads/bfg-1.12.16.jar ] ;then
    [[ ! -d /opt/lib ]] && sudo mkdir -p /opt/lib
    sudo cp ~/Downloads/bfg-1.12.16.jar /opt/lib
  fi
  if [ ! -f /opt/bin/bfg ] ;then
    [[ ! -d /opt/bin ]] && sudo mkdir -p /opt/bin
    __install_bfg_script | sudo tee /opt/bin/bfg > /dev/null
    sudo chmod 755 /opt/bin/bfg
    echo /opt/bin/bfg
  fi
}

function install_bfg {
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
