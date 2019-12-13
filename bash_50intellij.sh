#!/bin/sh

function intellij_reset_keyboard {
  ibus-daemon -rd
  sleep 3
  stty sane
  carpalx_hyena_gb
}

function intellij_clean {
  for base in $HOME/.IntelliJ* ;do
    for dir in caches jars js_caches jsp_related_caches compiler index compile-server ;do
      if [ -d $base/system/$dir ] ;then
        rm -r -f $base/system/$dir
      fi
    done
  done
}
