#!/bin/bash

function textLowerFirst() {
  local string="$1"
  local first=`echo $string|cut -c1|tr [A-Z] [a-z]`
  local second=`echo $string|cut -c2-`
  echo $first$second
}
