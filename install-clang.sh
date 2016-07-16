
#!/bin/bash

function clang_repository() {
sudo bash <<EOD
  echo "deb http://llvm.org/apt/jessie/     llvm-toolchain-jessie-3.8 main" >  /etc/apt/sources.list.d/llvm.list
  echo "deb-src http://llvm.org/apt/jessie/ llvm-toolchain-jessie-3.8 main" >> /etc/apt/sources.list.d/llvm.list
  wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | apt-key add -
EOD
}

function clang_install() {
  release=$1
  version=$2
  release=${release:="stable"}
  version=${version:="3.5"}
  echo "Installing clang-${version} and llvm-${version} from ${release} ..."
  sudo apt-get install -t ${release} \
       clang-${version} clang-${version}-doc clang-format-${version} \
       llvm-${version} llvm-${version}-doc llvm-${version}-examples \
       lldb-${version}
  sudo rm /usr/bin/llvm-config
  sudo rm /usr/bin/clang
  sudo rm /usr/bin/clang++

  sudo ln -s /usr/bin/llvm-config-${version} /usr/bin/llvm-config
  sudo ln -s /usr/bin/clang-${version}       /usr/bin/clang
  sudo ln -s /usr/bin/clang++-${version}     /usr/bin/clang++
}

clang_repository
clang_install stable 3.8
