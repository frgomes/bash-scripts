#!/bin/bash

set -euo pipefail

# Easy installation of Torch7 for Debian Jessie
# Credits: http://github.com/geco/ezinstall

sudo apt install qt4-default qt4-dev-tools libjpeg-dev libopenblas-dev libreadline-dev -y && \
  curl -s https://raw.githubusercontent.com/geco/ezinstall/patch-1/install-all | sudo bash
