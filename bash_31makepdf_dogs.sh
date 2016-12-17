#!/bin/bash

## List of files to be combined, in the correct order
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


function makepdf_dogs_builder {
  domain=stew.github.io
  path=dogs
  out=$HOME/Downloads/${path}.pdf

  [[ ! -d $domain/$path ]] && httrack http://$domain/$path
  makepdf_dogs_files | pdf_converter_and_combiner $out && echo $out
}


function makepdf_dogs {
  mkdir -p $HOME/websites && pushd $HOME/websites >> /dev/null
  msg=$(makepdf_dogs_builder)
  popd >> /dev/null
  echo $msg
}
