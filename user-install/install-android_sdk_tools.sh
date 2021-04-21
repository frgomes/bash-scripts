#!/bin/bash -eu

## https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip

function install_android_sdk_tools_binaries {
  local release=${1:-"$ANDROID_SDK_RELEASE"}
  local version=${2:-"$ANDROID_SDK_VERSION"}

  local release=${release:-"4333796"}
  local version=${version:-"29.0.0"}

  local api=$(echo ${version} | cut -d. -f1)
  local api=${3:-${api}}

  local HWPLATFORM=$(uname -m | tr [:upper:] [:lower:])
  local OSPLATFORM=$(uname -s | tr [:upper:] [:lower:])

  local archive=sdk-tools-${OSPLATFORM}-${release}.zip

  [[ ! -d "${DOWNLOADS}" ]] && mkdir -p "${DOWNLOADS}"
  pushd "${DOWNLOADS}" > /dev/null
  [[ ! -f ${archive} ]] && wget https://dl.google.com/android/repository/${archive}
  
  popd > /dev/null

  local tools=${TOOLS_HOME:=$HOME/tools}
  local folder=${tools}/sdk-tools-${OSPLATFORM}-${release}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${folder} ] ;then
    mkdir -p ${folder}
    pushd ${folder} > /dev/null
    unzip "${DOWNLOADS}"/${archive}
    popd > /dev/null
  fi

  cat << EOD > /tmp/android_sdkmanager.sh
#!/bin/bash

export JAVA_OPTS="-Djava.io.tmpdir=${HOME}/tmp"
echo y | ${folder}/tools/bin/sdkmanager \\
EOD

  ${folder}/tools/bin/sdkmanager --list 2> /dev/null | \
    fgrep -A 1000 "Available Packages:" | tail -n +4 | sed -r 's/[ \t]+/ /g' | cut -c 2- | cut -d' ' -f1 | \
      grep \
        -e "^extras;" \
        -e "^emulator" \
        -e "^cmake;3.10." \
        -e "^lldb;3.1" \
        -e "^patcher" \
        -e "^platform-tools" \
        -e "^platforms;android-${api}" \
        -e "^build-tools;${version}" \
        -e "^add-ons;addon-google_apis-google-${api}" \
        -e "^system-images;android-${api};" \
        -e "^ndk-bundle" \
        -e "^docs" \
        -e "^tools" | \
          while read line ;do
            echo "  \"${line}\" \\"
          done >> /tmp/android_sdkmanager.sh
  cat << EOD >> /tmp/android_sdkmanager.sh

${folder}/tools/bin/avdmanager \\
  create avd \\
    --name Nexus6P \\
    --device "Nexus 6P" \\
    --force \\
    --abi google_apis/${HWPLATFORM} \\
    --package 'system-images;android-${api};google_apis;${HWPLATFORM}' 
EOD

  echo "[Installing packages]"
  chmod 755 /tmp/android_sdkmanager.sh
  cat /tmp/android_sdkmanager.sh
  /tmp/android_sdkmanager.sh

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/350-android-sdk.sh
#!/bin/bash

export ANDROID_SDK_RELEASE=${release}
export ANDROID_SDK_VERSION=${version}
export HWPLATFORM=${HWPLATFORM}
export OSPLATFORM=${OSPLATFORM}

export ANDROID_SDK=${TOOLS_HOME}/sdk-tools-\${OSPLATFORM}-\${ANDROID_SDK_RELEASE}
export ANDROID_HOME=\${ANDROID_SDK}

export ANDROID_NDK=\${ANDROID_SDK}/ndk-bundle
export NDK_HOME=\${ANDROID_NDK}

export PATH=\${ANDROID_SDK}/tools:\${ANDROID_SDK}/tools/bin:\${PATH}
EOD
}


function install_android_sdk_tools {
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
