#!/bin/bash

###TODO: install wkhtmltopdf under /opt

 ##
## Convert HTML pages and combine theminto a single PDF
## See: http://wkhtmltopdf.org/index.html
###
function pdf_converter_and_combiner {
  local out=$1
  local  log=$(tempfile)
  local work=$log.dir

  egrep -v -e '^#' | \
    while read html ;do
      dir=$(dirname $html)
      name=$(basename $html .html)
      pdf=$work/$dir/$name.pdf

      mkdir -p $work/$dir                       >> $log 2>&1
      echo ============================== $html >> $log 2>&1
      /opt/wkhtmltox/bin/wkhtmltopdf $html $pdf >> $log 2>&1

      echo $pdf
    done | \
      xargs gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=$out >> $log 2>&1
}
