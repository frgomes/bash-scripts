#!/bin/bash

## List of files to be combined, in the correct order
function makepdf_circe_files {
cat <<EOD
circe.github.io/circe/index.html
#circe.github.io/circe/DESIGN.html
circe.github.io/circe/parsing.html
circe.github.io/circe/cursors.html
circe.github.io/circe/codec.html
circe.github.io/circe/optics.html
#circe.github.io/circe/monocle.html
circe.github.io/circe/performance.html
circe.github.io/circe/contributing.html
#circe.github.io/circe/index-2.html
EOD
}


function makepdf_circe {
  domain=circe.github.io
  path=circe

  local out=""${DOWNLOADS}"/${path}.pdf"

  httrack_fetch "$HOME/websites" "$domain" "$path" "http://$domain/$path"

  [[ -d "$HOME/websites/$domain/$path" ]] \
  && pushd "$HOME/websites/$domain/$path" >> /dev/null \
  &&   makepdf_circe_files | pdf_converter_and_combiner $out \
  && popd >> /dev/null \
  && echo $out
}
