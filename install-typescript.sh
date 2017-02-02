#!/bin/bash

# make sure all necessary tools are installed
if [ -e "$(which npm)" ] ;then
  npm install -g --save yarn && yarn global add typescript ntypescript typings@2.1.0 tslint@4.4.2
else
  echo "Please run: install-node.sh
fi
