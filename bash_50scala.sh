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
