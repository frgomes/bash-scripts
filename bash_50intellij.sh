#!/bin/sh

function intellij_clean {
  for home in $HOME/.IntelliJ* ;do
    for dir in caches jars js_caches jsp_related_caches compiler index compile-server ;do
      if [ -d $home/system/$dir ] ;then
        rm -r -f $home/system/$dir
      fi
    done
  done
}
