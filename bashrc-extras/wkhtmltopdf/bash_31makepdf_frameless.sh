#!/bin/bash

# TODO: Frameless employ frames!
#       I mean: the Frameless website employ frames, which confuses the convertion to PDF.


function makepdf_frameless_files {
cat <<EOD
#olivierblanvillain.github.io/frameless/index.html
olivierblanvillain.github.io/frameless/GettingStarted.html
olivierblanvillain.github.io/frameless/TypedDatasetVsSparkDataset.html
olivierblanvillain.github.io/frameless/TypedEncoder.html
olivierblanvillain.github.io/frameless/Injection.html
olivierblanvillain.github.io/frameless/Cats.html
olivierblanvillain.github.io/frameless/TypedDataFrame.html
#olivierblanvillain.github.io/dataframe/src/test/scala/BestNeighborhood.html
#olivierblanvillain.github.io/dataframe/src/test/scala/JoinTests.html
EOD
}


function makepdf_frameless {
  local domain=olivierblanvillain.github.io
  local path=frameless

  local out=""${DOWNLOADS}"/${path}.pdf"

  httrack_fetch "$HOME/websites" "$domain" "$path" "http://$domain/$path"

  [[ -d "$HOME/websites/$domain/$path" ]] \
  && pushd "$HOME/websites/$domain/$path" >> /dev/null \
  &&   makepdf_frameless_files | pdf_converter_and_combiner $out \
  && popd >> /dev/null \
  && echo $out
}
