#!/bin/bash

alias k='kubectl'
alias ky='kubectl -o yaml'

function kubectl_clusters {
  cat ~/.kube/config | yaml2json | jq '.clusters[].name' | sed 's/"//g'
}
