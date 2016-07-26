#!/bin/bash

function zap {
  find . -maxdepth 2 -type d \( -name target -o -name target_sbt -o -name .ensime_cache \) | xargs rm -r -f
  find .             -type d \( -name target -o -name target_sbt -o -name .ensime_cache \) | xargs rm -r -f
  find . -type f \( -name \~ -o -name '*~' \) | xargs rm -r -f
}
