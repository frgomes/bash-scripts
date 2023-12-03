#!/bin/bash -eu

## https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip

function install_android_sdk_tools_binaries {
  # define default arguments	
  local default_release=${ANDROID_SDK_RELEASE:-"10406996"}
  local default_version=${ANDROID_SDK_VERSION:-"33.0.2"}
  local default_tooling=latest

  # obtain arguments from command line parameters, if any
  local release=${1:-"$default_release"}
  local version=${2:-"$default_version"}
  local tooling=${3:-"$default_tooling"}

  # derive additional variables from arguments
  local api=$(echo ${version} | cut -d. -f1)
  local api=${4:-${api}}

  # obtain hardware and software platforms
  local HWPLATFORM=$(uname -m | tr '[:upper:]' '[:lower:]')
  local OSPLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')

  # define download archive name and URL
  local archive=commandlinetools-${OSPLATFORM}-${release}_${tooling}.zip ###FIXME: not tested when ${tooling} is other than "latest"
  local url=https://dl.google.com/android/repository/${archive}

  # download archive
  [[ ! -d "${DOWNLOADS}" ]] && mkdir -p "${DOWNLOADS}"
  pushd "${DOWNLOADS}" > /dev/null
  [[ ! -f ${archive} ]] && wget ${url}
  popd > /dev/null

  # create destination folder
  local tools=${TOOLS_HOME:=$HOME/tools}
  local folder=${tools}/commandlinetools-${OSPLATFORM}-${release}

  # extract archive into destination folder
  [[ ! -d ${folder}/cmdline-tools/ ]] && mkdir -p ${folder}
  unzip "${DOWNLOADS}"/${archive} -d ${folder}

  # THIS IS STUPID!
  # This step is required in the installation of commandline-tools since the ZIP file does not present the correct directory structure :-(
  mkdir -p ${folder}/cmdline-tools/${tooling}
  mv ${folder}/cmdline-tools/{bin,lib,NOTICE.txt,source.properties} ${folder}/cmdline-tools/${tooling}

  # At this point, I've opted for an arcane approach: create a script which performs the remaining installation steps.
  # Maybe in future I decide for a direct approach.
  # However, given that Google decided to rename things and change other details, it turns out that the current approach using
  # an installation script is preferrable since I can more easily debug the installation process and fix whatever needs to be fixed.

  # create installation script /tmp/android_sdkmanager.sh
##-----------------------------------------------------------------------------------------------------------------------------------
cat << EOD > /tmp/android_sdkmanager.sh
#!/bin/bash -eu

echo "[Define JAVA_OPTS]"
export JAVA_OPTS="-Djava.io.tmpdir=${HOME}/tmp"

echo "[Accept licenses]"
yes | ${folder}/cmdline-tools/${tooling}/bin/sdkmanager --licenses

echo "[Install packages]"
${folder}/cmdline-tools/${tooling}/bin/sdkmanager --install --verbose \\
EOD

##-----------------------------------------------------------------------------------------------------------------------------------

  # appends list of packages to be installed onto /tmp/android_sdkmanager.sh
  ${folder}/cmdline-tools/${tooling}/bin/sdkmanager --sdk_root=${folder} --list 2> /dev/null | \
    fgrep -A 1000 "Available Packages:" | tail -n +4 | sed -r 's/[ \t]+/ /g' | cut -c 2- | cut -d' ' -f1 | \
    tee /tmp/android_sdkmanager_list.txt | \
      grep \
        -e "^extras;android;" \
        -e "^extras;google;" \
        -e "^extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2$" \
        -e "^extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2$" \
        -e "^emulator" \
        -e "^cmake;3.22." \
        -e "^platform-tools" \
        -e "^platforms;android-${api}$" \
        -e "^build-tools;${version}$" \
        -e "^add-ons;addon-google_apis-google-${api}" \
        -e "^system-images;android-${api};" \
        -e "^ndk-bundle" | \
          while read line ;do
            echo "  \"${line}\" \\"
          done >> /tmp/android_sdkmanager.sh

  # appends virtual device configuration onto installation script /tmp/android_sdkmanager.sh
##-----------------------------------------------------------------------------------------------------------------------------------
  cat << EOD >> /tmp/android_sdkmanager.sh

echo "[Create virtual device]"
${folder}/cmdline-tools/${tooling}/bin/avdmanager \\
  create avd \\
    --name Nexus6P \\
    --device "Nexus 6P" \\
    --force \\
    --abi google_apis/${HWPLATFORM} \\
    --package 'system-images;android-${api};google_apis;${HWPLATFORM}'

echo "[Done]"
EOD
##-----------------------------------------------------------------------------------------------------------------------------------

  # define ANDROID_SDK and ANDROID_NDK
  export ANDROID_SDK=${folder}
  export ANDROID_NDK=${ANDROID_SDK}/cmdline-tools/${tooling}/ndk-bundle
  
  # create script to be executed when the current virtual environment is activated
  local group=800
  local name=android-sdk
  local script="${VIRTUAL_ENV:-${HOME}/.local/share/bash-scripts}"/postactivate/postactivate.d/${group}-${name}.sh
  [[ ! -d $(dirname "${script}") ]] && mkdir -p $(dirname "${script}")
  cat <<EOD > "${script}"
#!/bin/bash

export ANDROID_SDK_RELEASE=${release}
export ANDROID_SDK_VERSION=${version}
export ANDROID_SDK_TOOLING=${tooling}
export HWPLATFORM=${HWPLATFORM}
export OSPLATFORM=${OSPLATFORM}

export ANDROID_SDK=\${TOOLS:-\${HOME}/tools}/commandlinetools-\${OSPLATFORM}-\${ANDROID_SDK_RELEASE}
export ANDROID_NDK=\${ANDROID_SDK}/ndk-bundle

export ANDROID_HOME=\${ANDROID_SDK}
export NDK_HOME=\${ANDROID_NDK}

export PATH=\${ANDROID_SDK}/tools:\${ANDROID_SDK}/tools/bin:\${ANDROID_SDK}/platform-tools:\${ANDROID_SDK}/cmdline-tools/\${ANDROID_SDK_TOOLING}/bin:\${PATH}
EOD

  # source configuration script so that environment variables are available during installation of packages
  chmod 755 "${script}"
  source "${script}"

  # run the installation script /tmp/android_sdkmanager.sh
  echo "[Installing packages]"
  chmod 755 /tmp/android_sdkmanager.sh
  source /tmp/android_sdkmanager.sh

  echo "[Inform location of postactivation script]"
  echo "${script}"
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
