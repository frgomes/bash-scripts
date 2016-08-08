#!/bin/bash

##########################
## Scala and SBT utilities
##########################


function sbt_lazy_ci {
  function sbt_lazy_ci_git { while true ;do sleep 900; git pull; done }
  function sbt_lazy_ci_hg  { while true ;do sleep 900; hg  pull --update; done }

  function sbt_lazy_ci_tests {
    cmds=$*
    if [ ${#cmds} -eq 0 ] ;then
      cmds="clean test"
    fi

    if [ -f ./sbt ] ;then
      ./sbt ${cmds}
    else
      sbt ${cmds}
    fi
  }


  if [ -d .git ] ;then
    sbt_lazy_ci_git &
    sbt_lazy_ci_tests $*
  elif [ -d .hg ] ;then
    sbt_lazy_ci_hg &
    sbt_lazy_ci_tests $*
  fi
}
