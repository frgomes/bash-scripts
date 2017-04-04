#!/bin/bash -x

# make sure all necessary tools are installed
if [ -e "$(which npm)" ] ;then
  npm install -g --save yarn && yarn global add typescript ntypescript typings tslint angular/cli
  npm ls -g --depth=0
else
  echo "Please run: install-node.sh"
fi
