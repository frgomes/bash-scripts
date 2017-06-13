#!/bin/bash

function install_rust {
  local tools=${TOOLS_HOME:=$HOME/tools}
  [[ ! -d $tools ]] && mkdir -p $tools

  [[ ! -d $tools/cargo ]] && mkdir -p $tools/cargo
  [[ ! -L ~/.cargo ]] && ln -s $tools/cargo ~/.cargo
  curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y \
    && hash -r \
      && rustup update
}

install_rust

