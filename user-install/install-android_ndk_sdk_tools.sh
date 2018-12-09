#!/bin/bash 

// see: https://github.com/tomaka/rust-android-docker/blob/master/Dockerfile


function install_android_ndk {
  local release=${1:-"$ANDROID_NDK_RELEASE"}
  local version=${2:-"$ANDROID_NDK_VERSION"}
  local version=${release:-"r12b"}
  local version=${version:-"18"}

  local osplatform=$(uname -s | tr [:upper:] [:lower:])
  local hwplatform=$(uname -m | tr [:upper:] [:lower:])

  local archive=android-ndk-${release}-${osplatform}-${hwplatform}.zip

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads > /dev/null
  [[ ! -f ${archive} ]] && wget https://dl.google.com/android/repository/${archive}
  popd > /dev/null

  local tools=${TOOLS_HOME:=$HOME/tools}
  local folder=${tools}/android-ndk-${release}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${folder} ] ;then
    pushd ${tools} > /dev/null
    unzip ~/Downloads/${archive}
    popd > /dev/null
  fi

  echo ${folder}
}

function install_android_sdk_tools {
  local release=${1:-"$ANDROID_SDK_RELEASE"}
  local version=${2:-"$ANDROID_SDK_VERSION"}
  local release=${release:-"4333796"}
  local version=${version:-"26.0.1"}
  local HWPLATFORM=$(uname -m | tr [:upper:] [:lower:])
  local OSPLATFORM=$(uname -s | tr [:upper:] [:lower:])

  local archive=sdk-tools-${OSPLATFORM}-${release}.zip

  [[ ! -d ~/Downloads ]] && mkdir -p ~/Downloads
  pushd ~/Downloads > /dev/null
  [[ ! -f ${archive} ]] && wget https://dl.google.com/android/repository/${archive}
  
  popd > /dev/null

  local tools=${TOOLS_HOME:=$HOME/tools}
  local folder=${tools}/sdk-tools-${OSPLATFORM}-${release}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${folder} ] ;then
    mkdir -p ${folder}
    pushd ${folder} > /dev/null
    unzip ~/Downloads/${archive}
    popd > /dev/null
  fi

  ${folder}/tools/bin/sdkmanager --update
  echo y | ${folder}/tools/bin/sdkmanager "platform-tools" "platforms;android-${ANDROID_NDK_VERSION}" "build-tools;${ANDROID_SDK_VERSION}"

  echo ${folder}
}


install_android_ndk $*
install_android_sdk_tools $*
