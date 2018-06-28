#!/bin/bash

function install_heroku_cli {
  sudo add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"
  curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -
  sudo apt update
  sudo apt install heroku
}

install_heroku_cli
