#!/bin/bash

function install_r_exclude {
cat <<EOD
r-cran-adegraphics
r-cran-dplyr
r-cran-nnls
r-cran-phangorn
r-cran-rnexml
r-cran-taxize
r-cran-phylobase
r-cran-tidyr
EOD
}

function install_r {
    apt-cache -t jessie search "^r-.*" | cut -d' ' -f1 | fgrep -v -f <(r_exclude) | xargs sudo apt install -y
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  fgrep "function " $self | cut -d' ' -f2 | head -n -2
else
  # echo "Script is a subshell"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  cmd=$(fgrep "function " $self | cut -d' ' -f2 | head -n -2 | tail -1)
  # echo $cmd
  $cmd $*
fi
