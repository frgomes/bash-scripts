#!/bin/bash

function __install_r_exclude {
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

function install_r_binaries {
    apt-cache -t jessie search "^r-.*" | cut -d' ' -f1 | fgrep -v -f <(__install_r_exclude) | xargs sudo aptitude install -y
}

function install_r {
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd $*
  done
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(grep -E "^function " $self | cut -d' ' -f2 | tail -1)
  $cmd $*
fi
