#!/bin/bash

alias k='kubectl'

function yaml2json {
  python -c 'import sys, yaml, json; y=yaml.safe_load(sys.stdin.read()); print(json.dumps(y))'
}

function kubectl_clusters {
  cat ~/.kube/config | yaml2json | jq '.clusters[].name' | sed 's/"//g'
}
