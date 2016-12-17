#!/bin/bash


function makepdf_fetch_files {
cat <<EOD
47deg.github.io/fetch/index.html
#47deg.github.io/fetch/Fetch Simple & Efficient data access for Scala and Scala.html
47deg.github.io/fetch/docs.html
EOD
}


function makepdf_fetch {
  domain=47deg.github.io
  path=fetch

  local out="$HOME/Downloads/${path}.pdf"

  httrack_fetch "$HOME/websites" "$domain" "$path" httrack "http://$domain/$path"

  [[ -d "$HOME/websites/$domain/$path" ]] \
  && pushd "$HOME/websites/$domain/$path" >> /dev/null \
  &&   makepdf_fetch_files | pdf_converter_and_combiner $out \
  && popd >> /dev/null \
  && echo $out
}
