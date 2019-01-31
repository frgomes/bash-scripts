#!/bin/bash -x

# see: https://kubernetes.io/docs/tasks/tools/install-kubectl/
function install_minikube_kubectl {
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

  echo ${tools}/kube-${version} | tee -a ~/.bashrc-path-addons
}

# see: https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters
function install_minikube_kubectl_config {
  echo //TODO: config
}


function install_minikube {
    install_minikube_kubectl && install_minikube_kubectl_config
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  fgrep "function " $self | cut -d' ' -f2 | head -n -2
else
  # echo "Script is a subshell"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  cmd=$(fgrep "function " $self | cut -d' ' -f2 | head -n -2 | tail -1)
  # echo $cmd
  $cmd $*
fi
