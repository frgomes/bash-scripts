#!/bin/bash

## List of files to be combined, in the correct order
function makepdf_fetch_files {
cat <<EOD
47deg.github.io/fetch/index.html
#47deg.github.io/fetch/Fetch Simple & Efficient data access for Scala and Scala.html
47deg.github.io/fetch/docs.html
EOD
}


function makepdf_fetch_builder {
  domain=47deg.github.io
  path=fetch
  out=$HOME/Downloads/${path}.pdf

  [[ ! -d $domain/$path ]] && httrack http://$domain/$path
  makepdf_fetch_files | pdf_converter_and_combiner $out && echo $out
}


function makepdf_fetch {
  mkdir -p $HOME/websites && pushd $HOME/websites >> /dev/null
  msg=$(makepdf_fetch_builder)
  popd >> /dev/null
  echo $msg
}
