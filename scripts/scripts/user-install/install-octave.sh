#!/bin/bash

#repo=jessie-backports
repo=stable

sudo apt-get -t ${repo} install dynare octave octave-dataframe octave-econometrics octave-financial octave-statistics octave-tsa octave-htmldoc octave-info
