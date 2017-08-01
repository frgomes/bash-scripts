#!/bin/bash

## List of files to be combined, in the correct order
function makepdf_finch_files {
cat <<EOD
#---- root
finagle.github.io/finch/index.html
finagle.github.io/finch/user-guide.html
finagle.github.io/finch/cookbook.html
finagle.github.io/finch/best-practices.html
EOD
}


function makepdf_finch {
  domain=finagle.github.io
  path=finch

  local out="$HOME/Downloads/${path}.pdf"

  httrack_fetch "$HOME/websites" "$domain" "$path" httrack "http://$domain/$path"

  [[ -d "$HOME/websites/$domain/$path" ]] \
  && pushd "$HOME/websites/$domain/$path" >> /dev/null \
  &&   makepdf_finch_files | pdf_converter_and_combiner $out \
  && popd >> /dev/null \
  && echo $out
}
