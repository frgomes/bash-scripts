#!/bin/bash

## List of files to be combined, in the correct order
function makepdf_eff_files {
cat <<EOD
./atnos-org.github.io/eff/index.html
./atnos-org.github.io/eff/org.atnos.site.Introduction.html
./atnos-org.github.io/eff/org.atnos.site.Installation.html
./atnos-org.github.io/eff/org.atnos.site.Tutorial.html
./atnos-org.github.io/eff/org.atnos.site.OutOfTheBox.html
./atnos-org.github.io/eff/org.atnos.site.CreateEffects.html
./atnos-org.github.io/eff/org.atnos.site.TransformStack.html
./atnos-org.github.io/eff/org.atnos.site.MemberImplicits.html
./atnos-org.github.io/eff/org.atnos.site.ApplicativeEvaluation.html
EOD
}


function makepdf_eff {
  domain=atnos-org.github.io
  path=eff

  local out=""${DOWNLOADS}"/${path}.pdf"

  httrack_fetch "$HOME/websites" "$domain" "$path" "http://$domain/$path"

  [[ -d "$HOME/websites/$domain/$path" ]] \
  && pushd "$HOME/websites/$domain/$path" >> /dev/null \
  &&   makepdf_eff_files | pdf_converter_and_combiner $out \
  && popd >> /dev/null \
  && echo $out
}
