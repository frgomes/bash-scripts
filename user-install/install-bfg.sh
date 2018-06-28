#!/bin/bash

function install_bfg_download {
  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads > /dev/null
  [[ ! -f bfg-1.12.16.jar ]] \
    && wget -O ~/Downloads/bfg-1.12.16.jar http://repo1.maven.org/maven2/com/madgag/bfg/1.12.16/bfg-1.12.16.jar
  popd > /dev/null
}

function install_bfg_script {
cat << EOD
#!/bin/bash

java -jar /opt/lib/bfg-1.12.16.jar $*
EOD
}

function install_bfg {
  if [ -f ~/Downloads/bfg-1.12.16.jar ] ;then
    [[ ! -d /opt/lib ]] && sudo mkdir -p /opt/lib
    sudo cp ~/Downloads/bfg-1.12.16.jar /opt/lib
  fi
  if [ ! -f /opt/bin/bfg ] ;then
    [[ ! -d /opt/bin ]] && sudo mkdir -p /opt/bin
    install_bfg_script | sudo tee /opt/bin/bfg > /dev/null
    sudo chmod 755 /opt/bin/bfg
    echo /opt/bin/bfg
  fi
}


install_bfg_download && install_bfg
