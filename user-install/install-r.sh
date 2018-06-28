#!/bin/bash

function r_exclude() {
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

apt-cache -t jessie search "^r-.*" | cut -d' ' -f1 | fgrep -v -f <(r_exclude) | xargs sudo apt install -y
