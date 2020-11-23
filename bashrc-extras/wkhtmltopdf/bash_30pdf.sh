#!/bin/bash


function pdf_check_wkhtmltopdf {
  if [ X$(which wkhtmltopdf) == X ] ;then
    echo .
    echo "***********************************************"
    echo "* Please install wkhtmltox for your platform. *"
    echo "* See: http://wkhtmltopdf.org/downloads.html  *"
    echo "***********************************************"
    echo .
    return 1
  fi
}

 ##
## Convert HTML pages and combine theminto a single PDF
## See: http://wkhtmltopdf.org/index.html
###
function pdf_converter_and_combiner {
  local out=$1
  local  log=/tmp/bash_30pdf_$$
  local work=$log.dir

  egrep -v -e '^#' | \
    while read html ;do
      dir=$(dirname "$html")
      name=$(basename "$html" .html)
      pdf=$work/$dir/"$name".pdf

      mkdir -p $work/$dir                           >> $log 2>&1
      echo ============== Convert "$html" to "$pdf" >> $log 2>&1
      wkhtmltopdf "$html" "$pdf" >> $log 2>&1

      echo '"'"$pdf"'"'
    done | \
      xargs gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=$out >> $log 2>&1
}

pdf_check_wkhtmltopdf
