#!/bin/bash

# see: https://kubernetes.io/docs/tasks/tools/install-kubectl/

function install_kubectl_binaries {
  local version=${1:-"$KUBE_VERSION"}
  local version=${version:-$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)}

  local machine=$(uname -m)
  case "${machine}" in
    armv7l)
      local arch=arm
        ;;
    *)
      local arch=amd64
        ;;
  esac

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools} ]] && mkdir -p ${tools}
  
  if [ ! -d ${tools}/kube-${version} ] ;then
    pushd ${tools} > /dev/null
    [[ -e kube ]] && rm -r -f kube
    mkdir -p kube-${version}/bin
    pushd kube-${version}/bin > /dev/null
    curl -LO https://storage.googleapis.com/kubernetes-release/release/${version}/bin/linux/${arch}/kubectl
    chmod 755 kubectl
    popd > /dev/null
    ln -s kube-${version} kube
    popd > /dev/null
  fi

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cat << EOD > ~/.bashrc-scripts/installed/270-kubectl.sh
#!/bin/bash

export KUBE_VERSION=${version}
export KUBE_HOME=\${TOOLS_HOME:=\$HOME/tools}/kube-\${KUBE_VERSION}

export PATH=\${KUBE_HOME}/bin:\${PATH}
EOD
}

function install_kubectl_plugins {
  local version=${1:-"$KUBE_VERSION"}
  local version=${version:-$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)}

  local machine=$(uname -m)
  case "${machine}" in
    armv7l)
      local arch=arm
        ;;
    *)
      local arch=amd64
        ;;
  esac

  local tools=${TOOLS_HOME:=$HOME/tools}

  [[ ! -d ${tools}/kube-${version}/bin ]] && mkdir -p ${tools}/kube-${version}/bin
  pushd ${tools}/kube-${version}/bin > /dev/null

  wget -O kubectl-stash https://github.com/stashed/cli/releases/download/v0.3.1/kubectl-stash-linux-${arch} \
    && chmod +x kubectl-stash

  popd > /dev/null
}


function install_kubectl {
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
