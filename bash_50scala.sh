#!/bin/bash

##########################
## Scala and SBT utilities
##########################


function sbt_lazyci {
  function sbt_lazyci_git { while true ;do sleep 600; git pull; done }
  function sbt_lazyci_hg  { while true ;do sleep 600; hg  pull; done }

  function sbt_continuous_tests {
    if [ -f ./sbt ] ;then
      ./sbt clean ~test
    else
      sbt clean ~test
    fi
  }

  if [ -d .git ] ;then
    sbt_lazyci_git &
    sbt_continuous_tests
  elif [ -d .hg ] ;then
    sbt_lazyci_hg &
    sbt_continuous_tests
  fi
}
