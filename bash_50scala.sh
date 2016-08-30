#!/bin/bash

##########################
## Scala and SBT utilities
##########################

function sbt_runner {
  if [ -f ./sbt ] ;then
    ./sbt ${cmds}
  else
    sbt ${cmds}
  fi
}

function sbt_lazyci {
  function sbt_lazyci_git { while true ;do sleep 900; git pull; done }
  function sbt_lazyci_hg  { while true ;do sleep 900; hg  pull --update; done }

  function sbt_lazyci_tests {
    cmds=$*
    if [ ${#cmds} -eq 0 ] ;then
      cmds="clean test"
    fi
    sbt_runner ${cmds}
  }

  if [ -d .git ] ;then
    sbt_lazyci_git &
    sbt_lazyci_tests $*
  elif [ -d .hg ] ;then
    sbt_lazyci_hg &
    sbt_lazyci_tests $*
  fi
}

function sbt_offline {
   sbt "set offline:=true" $*
}

function sbt_online {
   sbt_runner "set offline:=false" $*
}
