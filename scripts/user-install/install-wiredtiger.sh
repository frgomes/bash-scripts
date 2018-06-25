#!/bin/bash -x

function wiredtiger_requirements {
  sudo apt update -y
  sudo apt install -y autoconf autogen intltool libtool make swig
}


function wiredtiger_install {
  [[ ! -d ~/workspace ]] && mkdir -p ~/workspace
  pushd ~/workspace

  if [ ! -d wiredtiger ] ;then
    git clone git://github.com/wiredtiger/wiredtiger.git
  else
    cd wiredtiger
    git pull
  fi

  local tools=${TOOLS_HOME:=$HOME/tools}
  [[ ! -d ${tools} ]] && mkdir -p ${tools}

  cd ~/workspace/wiredtiger
  ./autogen.sh
  ./configure --enable-java --prefix=${tools}/wiredtiger

  make
  make install

  popd

  mkdir -p ~/bin > /dev/null 2>&1
  ln -s ${tools}/wiredtiger/bin/wt ~/bin/wt

  echo $HOME/bin/wt
}

which autoconf && which autogen && which make && which swig && [[ ! -f $HOME/bin/wt ]] && wiredtiger_install
[[ -f $HOME/bin/wt ]]
