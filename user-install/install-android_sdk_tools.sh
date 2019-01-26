#!/bin/bash 

## https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip

function install_android_sdk_tools {
  local release=${1:-"$ANDROID_SDK_RELEASE"}
  local version=${2:-"$ANDROID_SDK_VERSION"}

  local release=${release:-"4333796"}
  local version=${version:-"28.0.3"}

  local api=$(echo ${version} | cut -d. -f1)
  local api=${3:-api}

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

  cat << EOD > /tmp/android_sdkmanager.sh
#!/bin/bash
export JAVA_OPTS="-Djava.io.tmpdir=${HOME}/tmp"
echo y | ${folder}/tools/bin/sdkmanager \\
EOD

  ${folder}/tools/bin/sdkmanager --list | \
    fgrep -A 1000 "Available Packages:" | tail +4 | sed -r 's/[ \t]+/ /g' | cut -c 2- | cut -d' ' -f1 | \
      grep \
        -e "^extras;" \
        -e "^emulator" \
        -e "^cmake;3.10." \
        -e "^lldb;3.1" \
        -e "^patcher" \
        -e "^platform-tools" \
        -e "^platforms;android-${version}" \
        -e "^build-tools;${version}" \
        -e "^add-ons;addon-google_apis-google-${api}" \
        -e "^system-images;android-${api};" \
        -e "^ndk-bundle" \
        -e "^docs" \
        -e "^tools" | \
          while read line ;do
            echo -n "  \"${line}\""
          done >> /tmp/android_sdkmanager.sh

  echo "" >> /tmp/android_sdkmanager.sh

  chmod 755 /tmp/android_sdkmanager.sh
  cat /tmp/android_sdkmanager.sh

  /tmp/android_sdkmanager.sh

  echo ${folder}
}

install_android_sdk_tools $*
