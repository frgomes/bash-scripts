#!/bin/bash

## List of files to be combined, in the correct order
function makepdf_cats_files {
cat <<EOD
#---- root
typelevel.org/cats/index.html
typelevel.org/cats/typeclasses/imports.html
#---- typeclasses
typelevel.org/cats/typeclasses.html
typelevel.org/cats/typeclasses/functor.html
typelevel.org/cats/typeclasses/semigroup.html
typelevel.org/cats/typeclasses/monoid.html
typelevel.org/cats/typeclasses/apply.html
typelevel.org/cats/typeclasses/applicative.html
typelevel.org/cats/typeclasses/traverse.html
typelevel.org/cats/typeclasses/monad.html
typelevel.org/cats/typeclasses/id.html
typelevel.org/cats/typeclasses/contravariant.html
typelevel.org/cats/typeclasses/invariant.html
typelevel.org/cats/typeclasses/foldable.html
typelevel.org/cats/typeclasses/monoidk.html
typelevel.org/cats/typeclasses/semigroupk.html
#---- datatypes
typelevel.org/cats/datatypes.html
typelevel.org/cats/datatypes/const.html
typelevel.org/cats/datatypes/either.html
typelevel.org/cats/datatypes/freeapplicative.html
typelevel.org/cats/datatypes/freemonad.html
typelevel.org/cats/datatypes/kleisli.html
typelevel.org/cats/datatypes/oneand.html
typelevel.org/cats/datatypes/optiont.html
typelevel.org/cats/datatypes/state.html
typelevel.org/cats/datatypes/validated.html
#---- root
typelevel.org/cats/resources_for_learners.html
typelevel.org/cats/faq.html
typelevel.org/cats/contributing.html
typelevel.org/cats/colophon.html
#---- discarded
# typelevel.org/cats/laws.html
# typelevel.org/cats/typeclasses/comonad.html
# typelevel.org/cats/typeclasses/optiont.html
# typelevel.org/cats/typeclasses/monadcombine.html
# typelevel.org/cats/typeclasses/monadfilter.html
# typelevel.org/cats/typeclasses/show.html
EOD
}


function makepdf_cats {
  domain=typelevel.org
  path=cats

  local out="$HOME/Downloads/${path}.pdf"

  httrack_fetch "$HOME/websites" "$domain" "$path" httrack "http://$domain/$path"

  [[ -d "$HOME/websites/$domain/$path" ]] \
  && pushd "$HOME/websites/$domain/$path" >> /dev/null \
  &&   makepdf_cats_files | pdf_converter_and_combiner $out \
  && popd >> /dev/null \
  && echo $out
}
