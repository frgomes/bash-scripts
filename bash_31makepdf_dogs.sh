#!/bin/bash


function makepdf_dogs_files {
cat <<EOD
stew.github.io/dogs/index.html
stew.github.io/dogs/tut/dequeue.html                                                                                                                                               
stew.github.io/dogs/tut/diet.html                                                                                                                                                  
stew.github.io/dogs/tut/enum.html                                                                                                                                                  
stew.github.io/dogs/tut/iset.html                                                                                                                                                  
stew.github.io/dogs/tut/list.html                                                                                                                                                  
stew.github.io/dogs/tut/option.html                                                                                                                                                
stew.github.io/dogs/tut/range.html                                                                                                                                                 
stew.github.io/dogs/tut/set.html
#stew.github.io/dogs/tut/order.html                                                                                                                                                 
stew.github.io/dogs/tut/listMatcher.html
EOD
}


function makepdf_dogs {
  domain=stew.github.io
  path=dogs

  local out="$HOME/Downloads/${path}.pdf"

  httrack_fetch "$HOME/websites" "$domain" "$path" httrack "http://$domain/$path"

  [[ -d "$HOME/websites/$domain/$path" ]] \
  && pushd "$HOME/websites/$domain/$path" >> /dev/null \
  &&   makepdf_dogs_files | pdf_converter_and_combiner $out \
  && popd >> /dev/null \
  && echo $out
}
