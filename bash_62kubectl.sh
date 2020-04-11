#!/bin/bash

alias k='kubectl'
alias ky='kubectl -o yaml'

function kubectl_clusters {
  cat ~/.kube/config | yaml2json | jq '.clusters[].name' | sed 's/"//g'
}

function kubectl_stats() {
  kubectl get secret,configmap,statefulset,deployment,svc,ing,pods,pvc,pv $*
}
