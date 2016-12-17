#!/bin/bash

function httrack_fetch {
  local dir=$1
  local domain=$2
  local path=$3

  shift; shift; shift

  [[ ! -d "$dir/$domain/$path" ]] \
    && mkdir -p "$dir/$domain/$path" \
      && pushd "$dir/$domain/$path" >> /dev/null \
        && httrack $* \
      && popd >> /dev/null
}
