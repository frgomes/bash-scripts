#!/bin/bash

function scala_expand_documentation() {
  for base in /opt/developer/DOCS/scala-docs-* ;do
    pushd $base/api > /dev/null 2>&1
    pwd
    # expand documentation from JAR files
    ls jars | \
      while read f ;do
        dir=$( echo $f | sed 's/-javadoc.jar//' )
        echo "    $dir"
        mkdir -p $dir
        pushd $dir > /dev/null 2>&1
        jar -xf ../jars/$f
        popd > /dev/null 2>&1
      done
    # expand documentation from .JAR files
    rm -r -f scala-library scala-compiler scala-reflect
    popd > /dev/null 2>&1
  done
}


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
