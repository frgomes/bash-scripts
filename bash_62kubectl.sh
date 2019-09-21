#!/bin/bash

alias k='kubectl'

function kubectl_clusters {
  cat ~/.kube/config | yaml2json | jq '.clusters[].name' | sed 's/"//g'
}
