#!/bin/bash

alias k='kubectl'
alias ky='kubectl -o yaml'

function kubectl_clusters {
  cat ~/.kube/config | yaml2json | jq '.clusters[].name' | sed 's/"//g'
}

function kubectl_stats {
  local resources=$(kubectl api-resources --namespaced=true | cut -d' ' -f1 | tail -n +2 | sort | uniq | mkString)
  kubectl get ${resources},pv $* 2> /dev/null
}

function kubectl_stats_cluster {
  local resources=$(kubectl api-resources --namespaced=false | cut -d' ' -f1 | tail -n +2 | sort | uniq | mkString)
  kubectl get ${resources} 2> /dev/null
}

function kubectl_certs {
  kubectl get -o wide certificate,certificaterequest,challenge,order,clusterissuer,issuer $*
}

function kubectl_events {
  kubectl get events --sort-by=.metadata.creationTimestamp $*
}
